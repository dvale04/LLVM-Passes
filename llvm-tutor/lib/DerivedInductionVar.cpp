/* DerivedInductionVar.cpp
 *
 * This pass detects derived induction variables using ScalarEvolution.
 *
 * Compatible with New Pass Manager
 */

#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/Value.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/Transforms/Utils/ScalarEvolutionExpander.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

namespace {

class DerivedInductionVar : public PassInfoMixin<DerivedInductionVar> {
public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM) {
    auto &LI = AM.getResult<LoopAnalysis>(F);
    auto &SE = AM.getResult<ScalarEvolutionAnalysis>(F);

    bool Changed = false;

    for (Loop *L : LI) {
      // part 2a: identifies induction variables
      // within inner loops of loop nests
      processInnerLoops(L, SE, Changed);
    }

    if (Changed) {
      return PreservedAnalyses::none();
    }
    return PreservedAnalyses::all();
  }

private:
  void processInnerLoops(Loop *L, ScalarEvolution &SE, bool &Changed) {
    // Process inner loops
    for (Loop *SubLoop : L->getSubLoops()) {
      processInnerLoops(SubLoop, SE, Changed);
    }
    // part 2b: eliminate the induction variables
    BasicBlock *Header = L->getHeader();
    if (!Header)
      return;

    errs() << "Analyzing loop in function " << Header->getParent()->getName()
           << ":\n";

    for (PHINode &PN : Header->phis()) {
      if (!PN.getType()->isIntegerTy())
        continue;
      const SCEV *S = SE.getSCEV(&PN);

      // Detect affine AddRec expressions
      if (auto *AR = dyn_cast<SCEVAddRecExpr>(S)) {
        const SCEV *Step = AR->getStepRecurrence(SE);
        const SCEV *Start = AR->getStart();

        // Check if it's affine
        if (AR->isAffine()) {
          errs() << "  Derived induction variable: " << PN.getName() << " = {"
                 << *Start << ",+," << *Step << "}<"
                 << L->getHeader()->getName() << ">\n";

          // part 2b: eliminate induction variables
          //  Generate IR code for the SCEV expression
          IRBuilder<> Builder(Header->getContext());
          SCEVExpander Expander(SE, Header->getModule()->getDataLayout(), "ive");
          for (Use &U : PN.uses()) {
            Instruction *UserInst = dyn_cast<Instruction>(U.getUser());
            if (!UserInst)
              continue;

            Builder.SetInsertPoint(UserInst);
            Value *Expanded = Expander.expandCodeFor(AR, PN.getType(), UserInst);
            UserInst->replaceUsesOfWith(&PN, Expanded);
            Changed = true;
          }

          //remove PHI node if no longer used
          if (PN.use_empty()) {
            PN.eraseFromParent();
          }
        }
      }
    }
  }
};

} // namespace

// Register the pass
llvm::PassPluginLibraryInfo getDerivedInductionVarPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "DerivedInductionVar", LLVM_VERSION_STRING,
          [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, FunctionPassManager &FPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                  if (Name == "derived-iv") {
                    FPM.addPass(DerivedInductionVar());
                    return true;
                  }
                  return false;
                });
          }};
}

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return getDerivedInductionVarPluginInfo();
}
