{-# LANGUAGE GADTs           #-}
{-# LANGUAGE TemplateHaskell #-}
-- |
-- Module      : Data.Array.Accelerate.LLVM.CodeGen.Ptr
-- Copyright   : [2016] Trevor L. McDonell
-- License     : BSD3
--
-- Maintainer  : Trevor L. McDonell <tmcdonell@cse.unsw.edu.au>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)
--

module Data.Array.Accelerate.LLVM.CodeGen.Ptr
  where

import LLVM.General.AST.Type.AddrSpace
import LLVM.General.AST.Type.Constant
import LLVM.General.AST.Type.Name
import LLVM.General.AST.Type.Operand
import LLVM.General.AST.Type.Representation

import Data.Array.Accelerate.Error


-- Treat an operand as a Ptr type. This is a hack because we can't unpack IR
-- terms of pointer type.
--
asPtr :: AddrSpace -> Operand t -> Operand (Ptr t)
asPtr as x =
  let
      retype :: Type a -> Type (Ptr a)
      retype VoidType     = $internalError "asPtr" "unexpected void type"
      retype (PrimType t) = PrimType (PtrPrimType t as)
      --
      rename :: Name a -> Name (Ptr a)
      rename (Name n)   = Name n
      rename (UnName n) = UnName n
  in
  case x of
    LocalReference t n                    -> LocalReference (retype t) (rename n)
    ConstantOperand (GlobalReference t n) -> ConstantOperand (GlobalReference (retype t) (rename n))
    ConstantOperand (UndefConstant t)     -> ConstantOperand (UndefConstant (retype t))
    ConstantOperand ScalarConstant{}      -> $internalError "asPtr" "unexpected scalar constant"

-- Treat a pointer operand as a scalar. This is a hack because we can't unpack
-- IR terms of pointer types.
--
unPtr :: Operand (Ptr t) -> Operand t
unPtr x =
  let
      retype :: Type (Ptr a) -> Type a
      retype (PrimType (PtrPrimType t _)) = PrimType t
      retype _                            = $internalError "unPtr" "expected pointer type"
      --
      rename :: Name (Ptr a) -> Name a
      rename (Name n)   = Name n
      rename (UnName n) = UnName n
  in
  case x of
    LocalReference t n                    -> LocalReference (retype t) (rename n)
    ConstantOperand (GlobalReference t n) -> ConstantOperand (GlobalReference (retype t) (rename n))
    ConstantOperand (UndefConstant t)     -> ConstantOperand (UndefConstant (retype t))
    ConstantOperand ScalarConstant{}      -> $internalError "unPtr" "unexpected scalar constant"

