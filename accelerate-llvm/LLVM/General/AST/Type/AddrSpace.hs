{-# OPTIONS_HADDOCK hide #-}
-- |
-- Module      : LLVM.General.AST.Type.AddrSpace
-- Copyright   : [2016] Trevor L. McDonell
-- License     : BSD3
--
-- Maintainer  : Trevor L. McDonell <tmcdonell@cse.unsw.edu.au>
-- Stability   : experimental
-- Portability : non-portable (GHC extensions)
--
-- Pointers exist in a particular address space
--

module LLVM.General.AST.Type.AddrSpace (

  AddrSpace(..),
  defaultAddrSpace,

) where

import LLVM.General.AST.AddrSpace


-- | The default address space is number zero. The semantics of non-zero address
-- spaces are target dependent.
--
defaultAddrSpace :: AddrSpace
defaultAddrSpace = AddrSpace 0

