open Core
open Ast

exception CodeGenError of string

type context_var = {
  id : string;
  var_t : type_def;
  loc : int;
  scope_level : int;
}

type context = {
  fun_name : string;
  scope_levelc : int;
  labelc : int;
  startlb : string list;
  endlb : string list;
  index : int;
  vars : context_var list;
  out : Out_channel.t;
}

let add_var id var_t ctx =
  { ctx with
    index = ctx.index - 8;
    vars = {id; var_t; loc=ctx.index; scope_level = ctx.scope_levelc} :: ctx.vars;}

let find_var id ctx =
  match List.find ctx.vars (fun v -> String.equal id v.id) with
  | Some v -> v
  | None -> raise (CodeGenError ("can't find " ^ id ^ " in the context"))

(* TODO *)
let get_var_level id ctx =
  match List.find ctx.vars (fun v -> String.equal id v.id) with
  | Some v -> Some v.scope_level
  | None -> None

let add_scope_level l ctx =
  { ctx with scope_levelc = ctx.scope_levelc + l;}

let inc_scope_level = add_scope_level 1

let get_new_label ?name ctx =
  match name with
  | Some n -> "L" ^ ctx.fun_name ^ n ^ (string_of_int ctx.labelc)
  | None -> "L" ^ ctx.fun_name ^ (string_of_int ctx.labelc)

let inc_labelc ctx =
  { ctx with labelc = ctx.labelc + 1; }

let keep_labelc ctx1 ctx2 =
  { ctx1 with labelc = ctx2.labelc; }

let set_labels lb0 lb1 ctx =
  { ctx with
    startlb = lb0 :: ctx.startlb;
    endlb = lb1:: ctx.endlb;}

let unset_labels ctx =
  (* print_string "!unset"; *)
  match ctx.startlb, ctx.endlb with
  | (_ :: sls), (_ :: els) ->
    { ctx with startlb = sls; endlb = els;}
  | _ -> raise (CodeGenError "unable to unset labels")
