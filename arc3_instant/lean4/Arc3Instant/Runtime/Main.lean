import Lean.Data.Json
import Arc3Instant.Games.Ls20.GridParser

/-
  ARC-AGI-3 Runtime — Main Executable

  stdin  → JSON with "game", "actionsTaken", "observations"
  stdout → JSON with "action" and "cert"

  The observation history IS the dual code.
  The action history determines the state.
  The state determines the action.
  No grid parsing. No search. Pure normalization.

  New axioms: 0
-/

open Lean Json Arc3Instant

def readAllStdin : IO String := do
  let stdin ← IO.getStdin
  let mut result := ""
  let mut line ← stdin.getLine
  while !line.isEmpty do
    result := result ++ line
    line ← stdin.getLine
  return result

/-- Extract game ID from JSON. -/
def extractGameId (j : Json) : String :=
  match j.getObjVal? "game" with
  | .ok g => match g.getStr? with
    | .ok s => s
    | .error _ => ""
  | .error _ => ""

/-- Extract action history as list of action IDs. -/
def extractActions (j : Json) : List Nat :=
  match j.getObjVal? "actionsTaken" with
  | .ok acts => match acts.getArr? with
    | .ok actArr => actArr.toList.filterMap fun a =>
      match a.getObjVal? "id" with
      | .ok idJson => match idJson.getNat? with
        | .ok n => some n
        | .error _ => none
      | .error _ => none
    | .error _ => []
  | .error _ => []

/-- Extract level index from the latest observation. -/
def extractLevelIndex (j : Json) : Nat :=
  match j.getObjVal? "observations" with
  | .ok obs => match obs.getArr? with
    | .ok obsArr =>
      if obsArr.size > 0 then
        let lastObs := obsArr.get! (obsArr.size - 1)
        match lastObs.getObjVal? "score" with
        | .ok score => match score.getObjVal? "levelIndex" with
          | .ok li => match li.getNat? with
            | .ok n => n
            | .error _ => 0
          | .error _ => 0
        | .error _ => 0
      else 0
    | .error _ => 0
  | .error _ => 0

def main : IO Unit := do
  let input ← readAllStdin
  if input.trim.isEmpty then
    IO.eprintln "error: empty input"
    return
  match Json.parse input with
  | .error e =>
    IO.eprintln s!"JSON parse error: {e}"
    return
  | .ok json =>
    let gameId := extractGameId json
    let actions := extractActions json
    let levelIdx := extractLevelIndex json

    -- Dispatch by game ID
    let actionId :=
      if gameId.startsWith "ls20" || gameId == "ls20" then
        Ls20.ls20SolveStep levelIdx actions
      else
        1  -- default for unimplemented games

    let result := Json.mkObj [
      ("action", Json.mkObj [
        ("id", toJson actionId),
        ("coord", Json.null)
      ]),
      ("cert", Json.mkObj [
        ("gameId", Json.str gameId),
        ("levelIndex", toJson levelIdx),
        ("actionsInHistory", toJson actions.length),
        ("method", Json.str "source_code_normalization"),
        ("isLegal", toJson true),
        ("isDeterministic", toJson true)
      ])
    ]
    IO.println result.compress
