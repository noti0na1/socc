
module MenhirBasics = struct
  
  exception Error
  
  type token = 
    | ReturnKeyword
    | ParenOpen
    | ParenClose
    | IntKeyword
    | Int of (
# 5 "parser.mly"
       (int)
# 15 "parser.ml"
  )
    | Id of (
# 7 "parser.mly"
       (string)
# 20 "parser.ml"
  )
    | EOF
    | Comma
    | Char of (
# 6 "parser.mly"
       (char)
# 27 "parser.ml"
  )
    | BraceOpen
    | BraceClose
  
end

include MenhirBasics

let _eRR =
  MenhirBasics.Error

type _menhir_env = {
  _menhir_lexer: Lexing.lexbuf -> token;
  _menhir_lexbuf: Lexing.lexbuf;
  _menhir_token: token;
  mutable _menhir_error: bool
}

and _menhir_state

# 1 "parser.mly"
  
  open Ast

# 52 "parser.ml"

let rec _menhir_discard : _menhir_env -> _menhir_env =
  fun _menhir_env ->
    let lexer = _menhir_env._menhir_lexer in
    let lexbuf = _menhir_env._menhir_lexbuf in
    let _tok = lexer lexbuf in
    {
      _menhir_lexer = lexer;
      _menhir_lexbuf = lexbuf;
      _menhir_token = _tok;
      _menhir_error = false;
    }

and prog : (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (
# 12 "parser.mly"
      (prog)
# 69 "parser.ml"
) =
  fun lexer lexbuf ->
    let _menhir_env =
      let (lexer : Lexing.lexbuf -> token) = lexer in
      let (lexbuf : Lexing.lexbuf) = lexbuf in
      ((let _tok = Obj.magic () in
      {
        _menhir_lexer = lexer;
        _menhir_lexbuf = lexbuf;
        _menhir_token = _tok;
        _menhir_error = false;
      }) : _menhir_env)
    in
    Obj.magic (let (_menhir_env : _menhir_env) = _menhir_env in
    let (_menhir_stack : 'freshtv67) = ((), _menhir_env._menhir_lexbuf.Lexing.lex_curr_p) in
    ((let _menhir_env = _menhir_discard _menhir_env in
    let _tok = _menhir_env._menhir_token in
    match _tok with
    | IntKeyword ->
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv63) = Obj.magic _menhir_stack in
        ((let _menhir_env = _menhir_discard _menhir_env in
        let _tok = _menhir_env._menhir_token in
        match _tok with
        | Id _v ->
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv59) = Obj.magic _menhir_stack in
            let (_v : (
# 7 "parser.mly"
       (string)
# 100 "parser.ml"
            )) = _v in
            ((let _menhir_stack = (_menhir_stack, _v) in
            let _menhir_env = _menhir_discard _menhir_env in
            let _tok = _menhir_env._menhir_token in
            match _tok with
            | ParenOpen ->
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : ('freshtv55) * (
# 7 "parser.mly"
       (string)
# 111 "parser.ml"
                )) = Obj.magic _menhir_stack in
                ((let _menhir_env = _menhir_discard _menhir_env in
                let _tok = _menhir_env._menhir_token in
                match _tok with
                | ParenClose ->
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : (('freshtv51) * (
# 7 "parser.mly"
       (string)
# 121 "parser.ml"
                    ))) = Obj.magic _menhir_stack in
                    ((let _menhir_env = _menhir_discard _menhir_env in
                    let _tok = _menhir_env._menhir_token in
                    match _tok with
                    | BraceOpen ->
                        let (_menhir_env : _menhir_env) = _menhir_env in
                        let (_menhir_stack : ((('freshtv47) * (
# 7 "parser.mly"
       (string)
# 131 "parser.ml"
                        )))) = Obj.magic _menhir_stack in
                        ((let _menhir_env = _menhir_discard _menhir_env in
                        let _tok = _menhir_env._menhir_token in
                        match _tok with
                        | ReturnKeyword ->
                            let (_menhir_env : _menhir_env) = _menhir_env in
                            let (_menhir_stack : 'freshtv43) = Obj.magic _menhir_stack in
                            ((let _menhir_env = _menhir_discard _menhir_env in
                            let _tok = _menhir_env._menhir_token in
                            match _tok with
                            | Int _v ->
                                let (_menhir_env : _menhir_env) = _menhir_env in
                                let (_menhir_stack : 'freshtv39) = Obj.magic _menhir_stack in
                                let (_v : (
# 5 "parser.mly"
       (int)
# 148 "parser.ml"
                                )) = _v in
                                ((let _menhir_env = _menhir_discard _menhir_env in
                                let (_menhir_env : _menhir_env) = _menhir_env in
                                let (_menhir_stack : 'freshtv37) = Obj.magic _menhir_stack in
                                let ((i : (
# 5 "parser.mly"
       (int)
# 156 "parser.ml"
                                )) : (
# 5 "parser.mly"
       (int)
# 160 "parser.ml"
                                )) = _v in
                                ((let _v : 'tv_exp = 
# 36 "parser.mly"
  ( Const (Int i) )
# 165 "parser.ml"
                                 in
                                let (_menhir_env : _menhir_env) = _menhir_env in
                                let (_menhir_stack : 'freshtv35) = _menhir_stack in
                                let (_v : 'tv_exp) = _v in
                                ((let _menhir_stack = (_menhir_stack, _v) in
                                let (_menhir_env : _menhir_env) = _menhir_env in
                                let (_menhir_stack : ('freshtv33) * 'tv_exp) = Obj.magic _menhir_stack in
                                ((assert (not _menhir_env._menhir_error);
                                let _tok = _menhir_env._menhir_token in
                                match _tok with
                                | Comma ->
                                    let (_menhir_env : _menhir_env) = _menhir_env in
                                    let (_menhir_stack : ('freshtv29) * 'tv_exp) = Obj.magic _menhir_stack in
                                    ((let _menhir_env = _menhir_discard _menhir_env in
                                    let (_menhir_env : _menhir_env) = _menhir_env in
                                    let (_menhir_stack : ('freshtv27) * 'tv_exp) = Obj.magic _menhir_stack in
                                    ((let (_menhir_stack, (e : 'tv_exp)) = _menhir_stack in
                                    let _3 = () in
                                    let _1 = () in
                                    let _v : 'tv_statement = 
# 31 "parser.mly"
  ( ReturnVal e )
# 188 "parser.ml"
                                     in
                                    let (_menhir_env : _menhir_env) = _menhir_env in
                                    let (_menhir_stack : 'freshtv25) = _menhir_stack in
                                    let (_v : 'tv_statement) = _v in
                                    ((let _menhir_stack = (_menhir_stack, _v) in
                                    let (_menhir_env : _menhir_env) = _menhir_env in
                                    let (_menhir_stack : ((((('freshtv23) * (
# 7 "parser.mly"
       (string)
# 198 "parser.ml"
                                    ))))) * 'tv_statement) = Obj.magic _menhir_stack in
                                    ((assert (not _menhir_env._menhir_error);
                                    let _tok = _menhir_env._menhir_token in
                                    match _tok with
                                    | BraceClose ->
                                        let (_menhir_env : _menhir_env) = _menhir_env in
                                        let (_menhir_stack : ((((('freshtv19) * (
# 7 "parser.mly"
       (string)
# 208 "parser.ml"
                                        ))))) * 'tv_statement) = Obj.magic _menhir_stack in
                                        ((let _menhir_env = _menhir_discard _menhir_env in
                                        let (_menhir_env : _menhir_env) = _menhir_env in
                                        let (_menhir_stack : ((((('freshtv17) * (
# 7 "parser.mly"
       (string)
# 215 "parser.ml"
                                        ))))) * 'tv_statement) = Obj.magic _menhir_stack in
                                        ((let ((_menhir_stack, (id : (
# 7 "parser.mly"
       (string)
# 220 "parser.ml"
                                        ))), (st : 'tv_statement)) = _menhir_stack in
                                        let _7 = () in
                                        let _5 = () in
                                        let _4 = () in
                                        let _3 = () in
                                        let _1 = () in
                                        let _v : (
# 13 "parser.mly"
      (fun_decl)
# 230 "parser.ml"
                                        ) = 
# 26 "parser.mly"
  ( Fun (id, st) )
# 234 "parser.ml"
                                         in
                                        let (_menhir_env : _menhir_env) = _menhir_env in
                                        let (_menhir_stack : 'freshtv15) = _menhir_stack in
                                        let (_v : (
# 13 "parser.mly"
      (fun_decl)
# 241 "parser.ml"
                                        )) = _v in
                                        ((let _menhir_stack = (_menhir_stack, _v) in
                                        let (_menhir_env : _menhir_env) = _menhir_env in
                                        let (_menhir_stack : 'freshtv13 * (
# 13 "parser.mly"
      (fun_decl)
# 248 "parser.ml"
                                        )) = Obj.magic _menhir_stack in
                                        ((assert (not _menhir_env._menhir_error);
                                        let _tok = _menhir_env._menhir_token in
                                        match _tok with
                                        | EOF ->
                                            let (_menhir_env : _menhir_env) = _menhir_env in
                                            let (_menhir_stack : 'freshtv9 * (
# 13 "parser.mly"
      (fun_decl)
# 258 "parser.ml"
                                            )) = Obj.magic _menhir_stack in
                                            ((let (_menhir_env : _menhir_env) = _menhir_env in
                                            let (_menhir_stack : 'freshtv7 * (
# 13 "parser.mly"
      (fun_decl)
# 264 "parser.ml"
                                            )) = Obj.magic _menhir_stack in
                                            ((let (_menhir_stack, (_1 : (
# 13 "parser.mly"
      (fun_decl)
# 269 "parser.ml"
                                            ))) = _menhir_stack in
                                            let _2 = () in
                                            let _v : (
# 12 "parser.mly"
      (prog)
# 275 "parser.ml"
                                            ) = 
# 21 "parser.mly"
  ( Prog [_1] )
# 279 "parser.ml"
                                             in
                                            let (_menhir_env : _menhir_env) = _menhir_env in
                                            let (_menhir_stack : 'freshtv5) = _menhir_stack in
                                            let (_v : (
# 12 "parser.mly"
      (prog)
# 286 "parser.ml"
                                            )) = _v in
                                            ((let (_menhir_env : _menhir_env) = _menhir_env in
                                            let (_menhir_stack : 'freshtv3) = Obj.magic _menhir_stack in
                                            let (_v : (
# 12 "parser.mly"
      (prog)
# 293 "parser.ml"
                                            )) = _v in
                                            ((let (_menhir_env : _menhir_env) = _menhir_env in
                                            let (_menhir_stack : 'freshtv1) = Obj.magic _menhir_stack in
                                            let ((_1 : (
# 12 "parser.mly"
      (prog)
# 300 "parser.ml"
                                            )) : (
# 12 "parser.mly"
      (prog)
# 304 "parser.ml"
                                            )) = _v in
                                            (Obj.magic _1 : 'freshtv2)) : 'freshtv4)) : 'freshtv6)) : 'freshtv8)) : 'freshtv10)
                                        | _ ->
                                            assert (not _menhir_env._menhir_error);
                                            _menhir_env._menhir_error <- true;
                                            let (_menhir_env : _menhir_env) = _menhir_env in
                                            let (_menhir_stack : 'freshtv11 * (
# 13 "parser.mly"
      (fun_decl)
# 314 "parser.ml"
                                            )) = Obj.magic _menhir_stack in
                                            (raise _eRR : 'freshtv12)) : 'freshtv14)) : 'freshtv16)) : 'freshtv18)) : 'freshtv20)
                                    | _ ->
                                        assert (not _menhir_env._menhir_error);
                                        _menhir_env._menhir_error <- true;
                                        let (_menhir_env : _menhir_env) = _menhir_env in
                                        let (_menhir_stack : ((((('freshtv21) * (
# 7 "parser.mly"
       (string)
# 324 "parser.ml"
                                        ))))) * 'tv_statement) = Obj.magic _menhir_stack in
                                        (raise _eRR : 'freshtv22)) : 'freshtv24)) : 'freshtv26)) : 'freshtv28)) : 'freshtv30)
                                | _ ->
                                    assert (not _menhir_env._menhir_error);
                                    _menhir_env._menhir_error <- true;
                                    let (_menhir_env : _menhir_env) = _menhir_env in
                                    let (_menhir_stack : ('freshtv31) * 'tv_exp) = Obj.magic _menhir_stack in
                                    (raise _eRR : 'freshtv32)) : 'freshtv34)) : 'freshtv36)) : 'freshtv38)) : 'freshtv40)
                            | _ ->
                                assert (not _menhir_env._menhir_error);
                                _menhir_env._menhir_error <- true;
                                let (_menhir_env : _menhir_env) = _menhir_env in
                                let (_menhir_stack : 'freshtv41) = Obj.magic _menhir_stack in
                                (raise _eRR : 'freshtv42)) : 'freshtv44)
                        | _ ->
                            assert (not _menhir_env._menhir_error);
                            _menhir_env._menhir_error <- true;
                            let (_menhir_env : _menhir_env) = _menhir_env in
                            let (_menhir_stack : (((('freshtv45) * (
# 7 "parser.mly"
       (string)
# 346 "parser.ml"
                            ))))) = Obj.magic _menhir_stack in
                            (raise _eRR : 'freshtv46)) : 'freshtv48)
                    | _ ->
                        assert (not _menhir_env._menhir_error);
                        _menhir_env._menhir_error <- true;
                        let (_menhir_env : _menhir_env) = _menhir_env in
                        let (_menhir_stack : ((('freshtv49) * (
# 7 "parser.mly"
       (string)
# 356 "parser.ml"
                        )))) = Obj.magic _menhir_stack in
                        (raise _eRR : 'freshtv50)) : 'freshtv52)
                | _ ->
                    assert (not _menhir_env._menhir_error);
                    _menhir_env._menhir_error <- true;
                    let (_menhir_env : _menhir_env) = _menhir_env in
                    let (_menhir_stack : (('freshtv53) * (
# 7 "parser.mly"
       (string)
# 366 "parser.ml"
                    ))) = Obj.magic _menhir_stack in
                    (raise _eRR : 'freshtv54)) : 'freshtv56)
            | _ ->
                assert (not _menhir_env._menhir_error);
                _menhir_env._menhir_error <- true;
                let (_menhir_env : _menhir_env) = _menhir_env in
                let (_menhir_stack : ('freshtv57) * (
# 7 "parser.mly"
       (string)
# 376 "parser.ml"
                )) = Obj.magic _menhir_stack in
                (raise _eRR : 'freshtv58)) : 'freshtv60)
        | _ ->
            assert (not _menhir_env._menhir_error);
            _menhir_env._menhir_error <- true;
            let (_menhir_env : _menhir_env) = _menhir_env in
            let (_menhir_stack : 'freshtv61) = Obj.magic _menhir_stack in
            (raise _eRR : 'freshtv62)) : 'freshtv64)
    | _ ->
        assert (not _menhir_env._menhir_error);
        _menhir_env._menhir_error <- true;
        let (_menhir_env : _menhir_env) = _menhir_env in
        let (_menhir_stack : 'freshtv65) = Obj.magic _menhir_stack in
        (raise _eRR : 'freshtv66)) : 'freshtv68))

# 38 "parser.mly"
  

# 395 "parser.ml"

# 219 "/home/noti0na1/.opam/4.06.1/lib/menhir/standard.mly"
  


# 401 "parser.ml"
