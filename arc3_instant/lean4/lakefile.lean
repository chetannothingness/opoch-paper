import Lake
open Lake DSL

package «Arc3Instant» where
  leanOptions := #[]

@[default_target]
lean_lib «Arc3Instant» where

lean_exe «arc3instant» where
  root := `Arc3Instant.Runtime.Main
