(module
 (import "env" "memory" (memory $0 256))
 (import "env" "memoryBase" (global $memoryBase i32))
 (import "env" "_puts" (func $puts (param i32) (result i32)))
 (import "env" "_readline" (func $readline (param i32) (result i32)))

 ;; Statically allocated data
 (data (get_global $memoryBase) "user> ")

 ;; These are initialized by $initMem
 (global $heapBase (mut i32) (i32.const 0))
 (global $stackBase (mut i32) (i32.const 0))

 ;; standard emscripten/wace memory layout initialization
 (func $initMem
  (block $label$0
   (set_global $heapBase
    (i32.add
     (get_global $memoryBase)
     ;; Length of static allocated data rounded up to
     ;; nearest multiple of 16
     (i32.const 16)
    )
   )
   (set_global $stackBase
    (i32.add
     (get_global $heapBase)
     ;; Out of 16M min memory:
     ;;   - first ~30% for heap
     ;;   - next ~70% above this for our C stack
     (i32.const 5242880)
    )
   )
  )
 )


 (func $READ (param $str i32) (result i32)
  (get_local $str))

 (func $EVAL (param $ast i32) (param $env i32) (result i32)
  (get_local $ast))

 (func $PRINT (param $ast i32) (result i32)
  (get_local $ast))

 (func $rep (param $str i32) (result i32)
  (call $PRINT
   (call $EVAL
    (call $READ (get_local $str))
    (i32.const 0))))

 (func $main (result i32)
  ;; Constant location/value definitions
  (local $line i32)

  ;; Start
  (loop $repl_loop
   (set_local $line
    (call $readline (get_global $memoryBase)))
   (if (get_local $line)
    (then
     (drop (call $puts (call $rep (get_local $line))))
     (br $repl_loop))))

  (i32.const 0))


 (export "_main" (func $main))
 (export "__post_instantiate" (func $initMem))
)

