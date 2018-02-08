-- A pruner that uses twee. Supports types and background axioms.
{-# LANGUAGE RecordWildCards, FlexibleContexts, FlexibleInstances, GADTs, PatternSynonyms, GeneralizedNewtypeDeriving, MultiParamTypeClasses, UndecidableInstances #-}
module QuickSpec.Pruning.Twee(Config(..), module QuickSpec.Pruning.Twee) where

import QuickSpec.Testing
import QuickSpec.Pruning
import QuickSpec.Term
import qualified QuickSpec.Pruning.Types as Types
import qualified QuickSpec.Pruning.Background as Background
import QuickSpec.Pruning.Background(Background)
import Control.Monad.Trans.State.Strict hiding (State)
import Control.Monad.Trans
import qualified QuickSpec.Pruning.UntypedTwee as Untyped
import QuickSpec.Pruning.UntypedTwee(Config(..))

newtype Pruner fun m a =
  Pruner (Background.Pruner fun (Types.Pruner fun (Untyped.Pruner (Types.Tagged fun) m)) a)
  deriving (Functor, Applicative, Monad, MonadIO, MonadTester testcase term, MonadPruner (Term fun))

instance MonadTrans (Pruner fun) where
  lift = Pruner . lift . lift . lift

run :: (Background fun, Monad m) => Config -> Pruner fun m a -> m a
run config (Pruner x) =
  Untyped.run config (Types.run (Background.run x))