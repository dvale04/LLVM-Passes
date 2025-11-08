/* SimpleLICM.cpp
 *
 * This pass hoists loop-invariant code before the loop when it is safe to do so.
 *
 * Compatible with New Pass Manage
*/

#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Dominators.h"
#include "llvm/IR/CFG.h"

#include "llvm/Pass.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"

#include "llvm/Analysis/LoopAnalysisManager.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/LoopPass.h"
#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/Analysis/ValueTracking.h"

#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "llvm/Transforms/Utils/LoopUtils.h"
#include "llvm/Transforms/Utils/ValueMapper.h"

using namespace llvm;

struct SimpleLICM : public PassInfoMixin<SimpleLICM> {
  PreservedAnalyses run(Loop &L, LoopAnalysisManager &AM,
                        LoopStandardAnalysisResults &AR,
                        LPMUpdater &) {
    DominatorTree &DT = AR.DT;

    BasicBlock *Preheader = L.getLoopPreheader();
    if (!Preheader) {
      errs() << "No preheader, skipping loop\n";
      return PreservedAnalyses::all();
    }

    SmallPtrSet<Instruction *, 8> InvariantSet;
    bool Change = true;

    // Worklist algorithm to identify loop invariant instructions
    /*************************************/
    /* Your code goes here */
    /*************************************/ 

    //worklist ← all loop instructions
    SmallVector<Instruction *, 32> Worklist;
    for (BasicBlock *BB : L.getBlocks()) {
      for (Instruction &I : * BB) {
        //skip instructions that read or write memory
        if (I.mayReadOrWriteMemory()) 
          continue;
        //skip phi instructions
        if (isa<PHINode>(I)) 
          continue;
        Worklist.push_back(&I);
      }
    }
    //invariant ← ∅ 
    bool changed;
    do {
      changed = false;
      SmallVector<Instruction *, 32> NewWorklist;

      //for i ∈ worklist
      for(Instruction *I : Worklist) {
        bool isInvariant = true;

        //manually check for operands if they are constants or loop invariants
        for (Value *Op : I->operands()) {
          if (Instruction *OpInst = dyn_cast<Instruction>(Op)) {
            //if operand is an instruction in loop, it must be in invariant set
            if (L.contains(OpInst->getParent()) && !InvariantSet.count(OpInst)) {
              isInvariant = false;
              break;
            }
          }
          //if not fixed constant and not argument, it's not invariant
          else if (!isa<Constant>(Op) && !isa<Argument>(Op)) {
            isInvariant = false;
            break;
          }
        }
        if (isInvariant) {
          InvariantSet.insert(I);
          //changed ← true
          changed = true;
        } else {
          NewWorklist.push_back(I);
        }
      }
      Worklist = NewWorklist;
      //loop ends until not changed, once no new invariants found
    } while (changed);

  

    // Actually hoist the instructions
    for (Instruction *I : InvariantSet) {
      if (isSafeToSpeculativelyExecute(I) && dominatesAllLoopExits(I, &L, DT)) {
        errs() << "Hoisting: " << *I << "\n";
        I->moveBefore(Preheader->getTerminator());
      }
    }

    return PreservedAnalyses::none();
  }

  bool dominatesAllLoopExits(Instruction *I, Loop *L, DominatorTree &DT) {
    SmallVector<BasicBlock *, 8> ExitBlocks;
    L->getExitBlocks(ExitBlocks);
    for (BasicBlock *EB : ExitBlocks) {
      if (!DT.dominates(I, EB))
        return false;
    }
    return true;
  }
};

llvm::PassPluginLibraryInfo getSimpleLICMPluginInfo() {
  errs() << "SimpleLICM plugin: getSimpleLICMPluginInfo() called\n";
  return {LLVM_PLUGIN_API_VERSION, "simple-licm", LLVM_VERSION_STRING,
          [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, LoopPassManager &LPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                  if (Name == "simple-licm") {
                    LPM.addPass(SimpleLICM());
                    return true;
                  }                  
                  return false;
                });
          }};
}

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  errs() << "SimpleLICM plugin: llvmGetPassPluginInfo() called\n";
  return getSimpleLICMPluginInfo();
}
