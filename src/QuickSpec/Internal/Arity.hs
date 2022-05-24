module QuickSpec.Internal.Arity (Arity(..)) where

import Twee.Term

class Arity f where
  -- | Measure the arity.
  arity :: f -> Int

instance (Labelled f, Arity f) => Arity (Fun f) where
  arity = arity . fun_value

