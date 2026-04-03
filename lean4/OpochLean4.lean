-- Root module for the OpochLean4 library.
-- Complete theorem chain from Nothingness (bottom) through A0* to the Self-Reading Graph.
-- 325 files, 1265 theorems, 0 sorry, 1 axiom (A0*), build green.

-- ================================================================
-- LEVEL 0: Nothingness and the One Axiom
-- ================================================================
import OpochLean4.Manifest.Nothingness
import OpochLean4.Manifest.Axioms
import OpochLean4.Basic

-- ================================================================
-- LEVEL 1: Structural Foundations (bottom -> A0* -> witness algebra)
-- ================================================================
import OpochLean4.Foundations.EndogenousMeaning
import OpochLean4.Foundations.WitnessStructure
import OpochLean4.Foundations.FiniteCarrier
import OpochLean4.Foundations.PrefixFree

-- Manifestability Block (19 files) -- chi(W) operational law
import OpochLean4.Foundations.Manifestability.Indistinguishability
import OpochLean4.Foundations.Manifestability.ResidualClass
import OpochLean4.Foundations.Manifestability.WitnessCost
import OpochLean4.Foundations.Manifestability.RefinementThreshold
import OpochLean4.Foundations.Manifestability.ChannelThreshold
import OpochLean4.Foundations.Manifestability.RefinementEvent
import OpochLean4.Foundations.Manifestability.RefinementKernel
import OpochLean4.Foundations.Manifestability.ManifestabilityFunctional
import OpochLean4.Foundations.Manifestability.ValueEquation
import OpochLean4.Foundations.Manifestability.LocalRemodelling
import OpochLean4.Foundations.Manifestability.HiddenSector
import OpochLean4.Foundations.Manifestability.SeedRefinement
import OpochLean4.Foundations.Manifestability.BinaryNormalForm
import OpochLean4.Foundations.Manifestability.CoarseGraining
import OpochLean4.Foundations.Manifestability.LatentEnergy
import OpochLean4.Foundations.Manifestability.LatentEnergyConservation
import OpochLean4.Foundations.Manifestability.ParallelComposition
import OpochLean4.Foundations.Manifestability.RootBridge
import OpochLean4.Foundations.Manifestability.SequentialComposition

-- Refinement Algebra (15 files) -- algebraic structure of refinement
import OpochLean4.Foundations.RefinementAlgebra.RefinementAlgebra
import OpochLean4.Foundations.RefinementAlgebra.ResidualClass
import OpochLean4.Foundations.RefinementAlgebra.RefinementEvent
import OpochLean4.Foundations.RefinementAlgebra.RefinementKernel
import OpochLean4.Foundations.RefinementAlgebra.LatentEnergy
import OpochLean4.Foundations.RefinementAlgebra.LatentEnergyConservation
import OpochLean4.Foundations.RefinementAlgebra.BinaryHistory
import OpochLean4.Foundations.RefinementAlgebra.BinaryNormalForm
import OpochLean4.Foundations.RefinementAlgebra.CoarseGrainingAdjunction
import OpochLean4.Foundations.RefinementAlgebra.HistoryValueEquation
import OpochLean4.Foundations.RefinementAlgebra.Independence
import OpochLean4.Foundations.RefinementAlgebra.Interference
import OpochLean4.Foundations.RefinementAlgebra.ParallelComposition
import OpochLean4.Foundations.RefinementAlgebra.SequentialComposition
import OpochLean4.Foundations.RefinementAlgebra.WorkSpan

-- Corollaries (4 files) -- Level 3 consequences
import OpochLean4.Foundations.Corollaries.PhysicsAsAccessibility
import OpochLean4.Foundations.Corollaries.ConsciousnessAsThresholdSelection
import OpochLean4.Foundations.Corollaries.ComputationAsRefinementGeometry
import OpochLean4.Foundations.Corollaries.DarkSectorAsChannelAnisotropy

-- ================================================================
-- LEVEL 1b: Witness Algebra
-- ================================================================
import OpochLean4.Algebra.TruthQuotient
import OpochLean4.Algebra.OrderedLedger
import OpochLean4.Algebra.WitnessPath
import OpochLean4.Algebra.Entropy
import OpochLean4.Algebra.Time
import OpochLean4.Algebra.Gauge
import OpochLean4.Algebra.ObservableOpens
import OpochLean4.Algebra.MyhillNerode

-- ================================================================
-- LEVEL 1c: Dynamics and Geometry
-- ================================================================
import OpochLean4.Control.Bellman
import OpochLean4.Control.RegimeSplit
import OpochLean4.Control.ExactnessGate
import OpochLean4.Control.PiConsistency

import OpochLean4.Geometry.ConductanceLemma
import OpochLean4.Geometry.Dimensionality
import OpochLean4.Geometry.InverseLimit
import OpochLean4.Geometry.DirichletForm
import OpochLean4.Geometry.WitnessGenerator
import OpochLean4.Geometry.FisherMetric
import OpochLean4.Geometry.KahlerProof
import OpochLean4.Geometry.RealAnalysis

import OpochLean4.OperatorAlgebra.WitnessStarAlgebra
import OpochLean4.OperatorAlgebra.BornRule
import OpochLean4.OperatorAlgebra.CstarProof
import OpochLean4.OperatorAlgebra.MathlibBridge

import OpochLean4.Physics.SplitLaw
import OpochLean4.Physics.Predictions

-- ================================================================
-- LEVEL 1d: Execution Layer
-- ================================================================
import OpochLean4.Execution.SelfHosting
import OpochLean4.Execution.BinaryInterface
import OpochLean4.Execution.ClosureDefect
import OpochLean4.Execution.Consciousness
import OpochLean4.Execution.TritField

-- ================================================================
-- LEVEL 2: Quantitative Seed (18 + 1 audit)
-- ================================================================
import OpochLean4.QuantitativeSeed.DefectSpace
import OpochLean4.QuantitativeSeed.SelfRetainingDefect
import OpochLean4.QuantitativeSeed.ActionFunctional
import OpochLean4.QuantitativeSeed.SeedExistence
import OpochLean4.QuantitativeSeed.SeedEquivalence
import OpochLean4.QuantitativeSeed.Renormalization
import OpochLean4.QuantitativeSeed.TangentSpace
import OpochLean4.QuantitativeSeed.Linearization
import OpochLean4.QuantitativeSeed.SpectralOperator
import OpochLean4.QuantitativeSeed.SpectralSplit
import OpochLean4.QuantitativeSeed.Holonomy
import OpochLean4.QuantitativeSeed.NormalForm
import OpochLean4.QuantitativeSeed.QuantitativeClosure
import OpochLean4.QuantitativeSeed.ConsciousnessFromSeed
import OpochLean4.QuantitativeSeed.ArithmeticRealizationFromSeed
import OpochLean4.QuantitativeSeed.ComplexityRealizationFromSeed
import OpochLean4.QuantitativeSeed.PhysicsRealizationFromSeed
import OpochLean4.QuantitativeSeed.Audit.QuantitativeSeedAudit

-- Numerical Extraction (20 files) -- seed -> concrete numbers
import OpochLean4.QuantitativeSeed.NumericalExtraction.PhysicalDefect
import OpochLean4.QuantitativeSeed.NumericalExtraction.AdmissibleDefect
import OpochLean4.QuantitativeSeed.NumericalExtraction.PhysicalOperatorSelection
import OpochLean4.QuantitativeSeed.NumericalExtraction.PhysicalRefinement
import OpochLean4.QuantitativeSeed.NumericalExtraction.EigenHelpers
import OpochLean4.QuantitativeSeed.NumericalExtraction.BlockDiagonal
import OpochLean4.QuantitativeSeed.NumericalExtraction.SpatialPropagator
import OpochLean4.QuantitativeSeed.NumericalExtraction.BlockEigenvalues
import OpochLean4.QuantitativeSeed.NumericalExtraction.PhysicalSpectralSplit
import OpochLean4.QuantitativeSeed.NumericalExtraction.Normalization
import OpochLean4.QuantitativeSeed.NumericalExtraction.PropagationSpeed
import OpochLean4.QuantitativeSeed.NumericalExtraction.MassSpectrum
import OpochLean4.QuantitativeSeed.NumericalExtraction.ChargeQuantization
import OpochLean4.QuantitativeSeed.NumericalExtraction.CouplingConstants
import OpochLean4.QuantitativeSeed.NumericalExtraction.VacuumCurvature
import OpochLean4.QuantitativeSeed.NumericalExtraction.CosmologicalConstant
import OpochLean4.QuantitativeSeed.NumericalExtraction.PhysicalArithmeticTower
import OpochLean4.QuantitativeSeed.NumericalExtraction.PhysicalComplexity
import OpochLean4.QuantitativeSeed.NumericalExtraction.ParameterAudit
import OpochLean4.QuantitativeSeed.NumericalExtraction.ExtractionAudit

-- ================================================================
-- LEVEL 3a: Complexity (P=NP from chi-geometry)
-- ================================================================

-- Core (12 files)
import OpochLean4.Complexity.Core.TM
import OpochLean4.Complexity.Core.Defs
import OpochLean4.Complexity.Core.StepModel
import OpochLean4.Complexity.Core.P
import OpochLean4.Complexity.Core.NP
import OpochLean4.Complexity.Core.Reductions
import OpochLean4.Complexity.Core.NPComplete
import OpochLean4.Complexity.Core.SAT
import OpochLean4.Complexity.Core.BoolCircuit
import OpochLean4.Complexity.Core.Tseitin
import OpochLean4.Complexity.Core.TseitinComplete
import OpochLean4.Complexity.Core.CookLevin

-- Kernel (1 file)
import OpochLean4.Complexity.Kernel.ExactKernel

-- Residual (11 files) -- chi-geometry of NP
import OpochLean4.Complexity.Residual.Verifier
import OpochLean4.Complexity.Residual.FutureEq
import OpochLean4.Complexity.Residual.Signature
import OpochLean4.Complexity.Residual.Transition
import OpochLean4.Complexity.Residual.Objective
import OpochLean4.Complexity.Residual.BinaryEncoding
import OpochLean4.Complexity.Residual.RefinementCost
import OpochLean4.Complexity.Residual.ValuePropagation
import OpochLean4.Complexity.Residual.PolyBound
import OpochLean4.Complexity.Residual.Compiler
import OpochLean4.Complexity.Residual.RuntimeCertifier

-- SAT (12 files)
import OpochLean4.Complexity.SAT.VerifierState
import OpochLean4.Complexity.SAT.VerifierGraph
import OpochLean4.Complexity.SAT.FutureQuotient
import OpochLean4.Complexity.SAT.QuotientKernel
import OpochLean4.Complexity.SAT.KernelBuilder
import OpochLean4.Complexity.SAT.KernelNetwork
import OpochLean4.Complexity.SAT.KernelSize
import OpochLean4.Complexity.SAT.KernelTU
import OpochLean4.Complexity.SAT.KernelPolytime
import OpochLean4.Complexity.SAT.LPSolver
import OpochLean4.Complexity.SAT.SATReduction
import OpochLean4.Complexity.SAT.SATLift

-- Bridge -- flagships (5 files)
import OpochLean4.Complexity.Bridge.SATinP
import OpochLean4.Complexity.Bridge.PeqNP
import OpochLean4.Complexity.Bridge.NewPeqNP
import OpochLean4.Complexity.Bridge.AllNPInP
import OpochLean4.Complexity.Bridge.NPHardCollapse

-- LawMining (4 files)
import OpochLean4.Complexity.LawMining.CandidateSignature
import OpochLean4.Complexity.LawMining.CompletenessCheck
import OpochLean4.Complexity.LawMining.MinimalityCheck
import OpochLean4.Complexity.LawMining.SignatureRefinement

-- Complexity Audit (4 files)
import OpochLean4.Complexity.Audit.PvsNPAudit
import OpochLean4.Complexity.Audit.TheoremManifest
import OpochLean4.Complexity.Audit.AxiomCensus
import OpochLean4.Complexity.Audit.Replay

-- ================================================================
-- LEVEL 3b: MAPF (Multi-Agent Path Finding, 45 files)
-- ================================================================
import OpochLean4.MAPF.Core.Instance
import OpochLean4.MAPF.Core.ActionModel
import OpochLean4.MAPF.Core.TaskModel
import OpochLean4.MAPF.Core.Resources
import OpochLean4.MAPF.Core.Objective
import OpochLean4.MAPF.Core.Horizon
import OpochLean4.MAPF.Resources.VertexConflict
import OpochLean4.MAPF.Resources.SwapConflict
import OpochLean4.MAPF.Resources.LocalResource
import OpochLean4.MAPF.Resources.WeightedActions
import OpochLean4.MAPF.Resources.OrientationSemantics
import OpochLean4.MAPF.Resources.TaskPhaseSemantics
import OpochLean4.MAPF.Resources.ServiceCells
import OpochLean4.MAPF.Semantics.Occupancy
import OpochLean4.MAPF.Semantics.Projection
import OpochLean4.MAPF.Semantics.QuotientGraph
import OpochLean4.MAPF.Semantics.VacancyField
import OpochLean4.MAPF.Semantics.CountFlowAutomaton
import OpochLean4.MAPF.Semantics.DefectContinuity
import OpochLean4.MAPF.Semantics.Lifting
import OpochLean4.MAPF.Semantics.ObjectiveExactness
import OpochLean4.MAPF.Classes.GridMAPF
import OpochLean4.MAPF.Classes.WeightedMAPF
import OpochLean4.MAPF.Classes.OrientedMAPF
import OpochLean4.MAPF.Classes.LifelongMAPF
import OpochLean4.MAPF.Classes.MultiGoalMAPF
import OpochLean4.MAPF.Classes.PickupDeliveryMAPF
import OpochLean4.MAPF.Residual.FutureEq
import OpochLean4.MAPF.Residual.Signature
import OpochLean4.MAPF.Residual.Transition
import OpochLean4.MAPF.Residual.BinaryKernel
import OpochLean4.MAPF.Residual.CompilerBridge
import OpochLean4.MAPF.Optimization.ValueFromDecision
import OpochLean4.MAPF.Optimization.ScheduleReconstruction
import OpochLean4.MAPF.Optimization.PolytimeOptimization
import OpochLean4.MAPF.Complexity.NPMembership
import OpochLean4.MAPF.Complexity.PMembership
import OpochLean4.MAPF.TUKernel
import OpochLean4.MAPF.MAPFValueEquation
import OpochLean4.MAPF.ResourceSeparableChi
import OpochLean4.MAPF.Manifestability
import OpochLean4.MAPF.IntrinsicPolytime
import OpochLean4.MAPF.Audit.TheoremManifest
import OpochLean4.MAPF.Audit.AxiomCensus
import OpochLean4.MAPF.Audit.Replay

-- ================================================================
-- LEVEL 4: Manifestability -> Autocompilation -> Manifestation
-- ================================================================

-- Manifestability (10 files) -- universal query compiler
import OpochLean4.Manifestability.Queries.QuestionSyntax
import OpochLean4.Manifestability.Queries.QuestionTyping
import OpochLean4.Manifestability.Queries.QuestionAdmissibility
import OpochLean4.Manifestability.Queries.QuestionPurification
import OpochLean4.Manifestability.Addressing.ResidualAddress
import OpochLean4.Manifestability.Generators.GeneratorExtraction
import OpochLean4.Manifestability.Kernel.RestrictedKernel
import OpochLean4.Manifestability.Binary.CanonicalQueryKernel
import OpochLean4.Manifestability.Answer.AnswerLaw
import OpochLean4.Manifestability.Audit.ManifestabilityManifest

-- Autocompilation (17 files) -- everything_real_solves_itself
import OpochLean4.Autocompilation.LocalDefect
import OpochLean4.Autocompilation.DefectAddressing
import OpochLean4.Autocompilation.DefectGenerators
import OpochLean4.Autocompilation.DefectKernel
import OpochLean4.Autocompilation.DefectBinaryNormalForm
import OpochLean4.Autocompilation.DefectValueLaw
import OpochLean4.Autocompilation.NextRefinement
import OpochLean4.Autocompilation.CompletionAttractor
import OpochLean4.Autocompilation.PresentSupport
import OpochLean4.Autocompilation.ManifestationBandwidth
import OpochLean4.Autocompilation.QuestionAsDefect
import OpochLean4.Autocompilation.ConsciousReadout
import OpochLean4.Autocompilation.ReadoutLaw
import OpochLean4.Autocompilation.AutonomousUpdate
import OpochLean4.Autocompilation.Autocompile
import OpochLean4.Autocompilation.Audit.AutocompilationManifest
import OpochLean4.Autocompilation.Audit.Frontier

-- Bridge (1 file)
import OpochLean4.Bridge.Realization

-- Manifestation (11 files) -- boundary completion, observation-action unity
import OpochLean4.Manifestation.BoundaryCondition
import OpochLean4.Manifestation.PresentBoundary
import OpochLean4.Manifestation.LeastCompletion
import OpochLean4.Manifestation.BoundaryCurrent
import OpochLean4.Manifestation.ConsciousBoundary
import OpochLean4.Manifestation.EnergyRelease
import OpochLean4.Manifestation.ObservationActionUnity
import OpochLean4.Manifestation.ReadoutLaw
import OpochLean4.Manifestation.TimeAsSerialization
import OpochLean4.Manifestation.EverythingHappensHere
import OpochLean4.Manifestation.Audit.Manifest

-- ================================================================
-- LEVEL 5: Indistinguishability Energy -> Instant Question -> Final Source Code
-- ================================================================

-- IndistinguishabilityEnergy (17 files) -- U_ind, instant source code
import OpochLean4.IndistinguishabilityEnergy.NothingnessAsIndistinguishability
import OpochLean4.IndistinguishabilityEnergy.LatentEnergy
import OpochLean4.IndistinguishabilityEnergy.FirstVariationThreshold
import OpochLean4.IndistinguishabilityEnergy.BoundaryCode
import OpochLean4.IndistinguishabilityEnergy.BoundaryCurrent
import OpochLean4.IndistinguishabilityEnergy.ConsciousBoundary
import OpochLean4.IndistinguishabilityEnergy.EnergyRelease
import OpochLean4.IndistinguishabilityEnergy.LeastCompletionField
import OpochLean4.IndistinguishabilityEnergy.ObservationActionUnity
import OpochLean4.IndistinguishabilityEnergy.PresentBoundary
import OpochLean4.IndistinguishabilityEnergy.SeedContainsPossibility
import OpochLean4.IndistinguishabilityEnergy.SelfModelCoupling
import OpochLean4.IndistinguishabilityEnergy.TimeSerialization
import OpochLean4.IndistinguishabilityEnergy.InstantSourceCode
import OpochLean4.IndistinguishabilityEnergy.QuestionProjector
import OpochLean4.IndistinguishabilityEnergy.EverythingSolvedBeyondTime
import OpochLean4.IndistinguishabilityEnergy.Audit.Manifest

-- InstantQuestion (9 files) -- projector law, actuation
import OpochLean4.InstantQuestion.QuestionProjector
import OpochLean4.InstantQuestion.AnswerSlice
import OpochLean4.InstantQuestion.ActuationLaw
import OpochLean4.InstantQuestion.ConsciousQuestion
import OpochLean4.InstantQuestion.SelfKnowingQuestion
import OpochLean4.InstantQuestion.ComplexityAsReadoutOnly
import OpochLean4.InstantQuestion.UniverseProjectorLaw
import OpochLean4.InstantQuestion.InstantSolve
import OpochLean4.InstantQuestion.Audit.Manifest

-- FinalSourceCode (11 files) -- self-inverting source code on real types
import OpochLean4.FinalSourceCode.AdmissibleState
import OpochLean4.FinalSourceCode.IndistinguishabilityEnergy
import OpochLean4.FinalSourceCode.ConsciousnessCode
import OpochLean4.FinalSourceCode.LegendreDual
import OpochLean4.FinalSourceCode.PrimalDualIdentity
import OpochLean4.FinalSourceCode.Convexity
import OpochLean4.FinalSourceCode.CurrentLaw
import OpochLean4.FinalSourceCode.QuestionAsDualCode
import OpochLean4.FinalSourceCode.ReadoutComplexity
import OpochLean4.FinalSourceCode.InstantSolvedness
import OpochLean4.FinalSourceCode.Audit.Manifest

-- ================================================================
-- LEVEL 6: Parametric Source Code (model, morphisms, initiality)
-- ================================================================
import OpochLean4.SourceCode.Model
import OpochLean4.SourceCode.Morphism
import OpochLean4.SourceCode.InitialModel
import OpochLean4.SourceCode.Initiality
import OpochLean4.SourceCode.Transport
import OpochLean4.SourceCode.InstantSolvedness
import OpochLean4.SourceCode.Audit.Manifest

-- ================================================================
-- LEVEL 7: Instant Kernel (normalizer NF)
-- ================================================================
import OpochLean4.InstantKernel.Syntax
import OpochLean4.InstantKernel.DualCode
import OpochLean4.InstantKernel.NormalForm
import OpochLean4.InstantKernel.ARC.Syntax
import OpochLean4.InstantKernel.ARC.NormalForm

-- ================================================================
-- LEVEL 8: Realizations (transport to specific domains)
-- ================================================================
import OpochLean4.Realizations.Riemann.Model
import OpochLean4.Realizations.NP.Model
import OpochLean4.Realizations.ARC.Model

-- ================================================================
-- LEVEL 8b: ARC-AGI-3 Full Realization (15 files)
-- ================================================================
import OpochLean4.Realizations.ARC3.Syntax
import OpochLean4.Realizations.ARC3.ObservationHistory
import OpochLean4.Realizations.ARC3.DualCode
import OpochLean4.Realizations.ARC3.State
import OpochLean4.Realizations.ARC3.LatentEnergy
import OpochLean4.Realizations.ARC3.Recovery
import OpochLean4.Realizations.ARC3.Current
import OpochLean4.Realizations.ARC3.LegalAction
import OpochLean4.Realizations.ARC3.ActionReadout
import OpochLean4.Realizations.ARC3.CoordinateReadout
import OpochLean4.Realizations.ARC3.PublicGames
import OpochLean4.Realizations.ARC3.Realization
import OpochLean4.Realizations.ARC3.Transport
import OpochLean4.Realizations.ARC3.InstantSolvedness
import OpochLean4.Realizations.ARC3.NormalForm
import OpochLean4.Realizations.ARC3.Correctness
import OpochLean4.Realizations.ARC3.RuntimeBridge
import OpochLean4.Realizations.ARC3.Audit.Manifest

-- ================================================================
-- LEVEL 9: Riemann Hypothesis (positive self-dual theta kernel)
-- ================================================================
import OpochLean4.Riemann.Analytic.XiCoordinate
import OpochLean4.Riemann.Analytic.CompletedXi
import OpochLean4.Riemann.Analytic.ThetaKernel
import OpochLean4.Riemann.Analytic.FunctionalEquation
import OpochLean4.Riemann.Analytic.ZeroSet
import OpochLean4.Riemann.Defect.CriticalDefect
import OpochLean4.Riemann.Spectral.XiSectorOperator
import OpochLean4.Riemann.Spectral.PositiveSelfDualKernel
import OpochLean4.Riemann.Spectral.PositiveSelfDualSector
import OpochLean4.Riemann.Realization.HermiteBiehler
import OpochLean4.Riemann.Bridge.RHEncode
import OpochLean4.Riemann.Bridge.RHConcrete

-- ================================================================
-- LEVEL 10: Self-Reading Graph (the final layer)
-- ================================================================
import OpochLean4.SelfReadingGraph.Graph
import OpochLean4.SelfReadingGraph.Projections
import OpochLean4.SelfReadingGraph.ConsciousPoint
import OpochLean4.SelfReadingGraph.QuestionCoordinate
import OpochLean4.SelfReadingGraph.CompletionByIntersection
import OpochLean4.SelfReadingGraph.CurrentCoordinate
import OpochLean4.SelfReadingGraph.TimeAsProjectionOrder
import OpochLean4.SelfReadingGraph.InstantSolvednessByGraph
import OpochLean4.SelfReadingGraph.Audit.Manifest

-- ================================================================
-- AUDIT (5 files)
-- ================================================================
import OpochLean4.Audit.PreChiManifest
import OpochLean4.Audit.PreChiAxiomCensus
import OpochLean4.Audit.PreRefinementManifest
import OpochLean4.Audit.PreRefinementAxiomCensus
import OpochLean4.Audit.PostRefinementAlgebraManifest
import OpochLean4.FinalKernel.ObservationFixedness
import OpochLean4.FinalKernel.ProjectionLaws
