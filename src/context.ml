open Core

exception CodeGenError of string

type context = {
  fun_name : string;
  block_level : int;
  labelc : int;
  startlb : string list;
  endlb : string list;
  index : int;
  vars : (string * (int * int)) list;
  out : Out_channel.t;
}

let add_var id ctx =
  { fun_name = ctx.fun_name;
    index = ctx.index - 8; (* 64-bit *)
    block_level = ctx.block_level;
    labelc = ctx.labelc;
    startlb = ctx.startlb;
    endlb = ctx.endlb;
    vars = (id, (ctx.index, ctx.block_level)) :: ctx.vars;
    out = ctx.out }

let find_var id ctx =
  match List.Assoc.find ctx.vars id ~equal:String.equal with
  | Some (i, _) -> i
  | None -> raise (CodeGenError ("can't find " ^ id ^ " in the context"))

(* TODO *)
let get_var_level id ctx =
  match List.Assoc.find ctx.vars id ~equal:String.equal with
  | Some (_, l) -> Some l
  | None -> None

let add_block_level l ctx=
  { fun_name = ctx.fun_name;
    index = ctx.index;
    block_level = ctx.block_level + l;
    labelc = ctx.labelc;
    startlb = ctx.startlb;
    endlb = ctx.endlb;
    vars = ctx.vars;
    out = ctx.out }

let inc_block_level = add_block_level 1

let get_new_label ?name ctx =
  match name with
  | Some n -> "L" ^ ctx.fun_name ^ n ^ (string_of_int ctx.labelc)
  | None -> "L" ^ ctx.fun_name ^ (string_of_int ctx.labelc)

let inc_labelc ctx =
  { fun_name = ctx.fun_name;
    index = ctx.index;
    block_level = ctx.block_level;
    labelc = ctx.labelc + 1;
    startlb = ctx.startlb;
    endlb = ctx.endlb;
    vars = ctx.vars;
    out = ctx.out }

let keep_labelc ctx1 ctx2 =
  { fun_name = ctx1.fun_name;
    index = ctx1.index;
    block_level = ctx1.block_level;
    labelc = ctx2.labelc;
    startlb = ctx1.startlb;
    endlb = ctx1.endlb;
    vars = ctx1.vars;
    out = ctx1.out }

let set_labels lb0 lb1 ctx =
  (* print_string "!set"; *)
  { fun_name = ctx.fun_name;
    index = ctx.index;
    block_level = ctx.block_level;
    labelc = ctx.labelc;
    startlb = lb0 :: ctx.startlb;
    endlb = lb1:: ctx.endlb;
    vars = ctx.vars;
    out = ctx.out }

let unset_labels ctx =
  (* print_string "!unset"; *)
  match ctx.startlb, ctx.endlb with
  | (_ :: sls), (_ :: els) ->
    { fun_name = ctx.fun_name;
      index = ctx.index;
      block_level = ctx.block_level;
      labelc = ctx.labelc;
      startlb = sls;
      endlb = els;
      vars = ctx.vars;
      out = ctx.out }
  | _ -> raise (CodeGenError "unable to unset labels")
