--usage parseProgram "file_name"
module Inter2 where

import Parser
import Data.Char
import Data.List

-- Defenition of expression data and types
type X = String
data Exp = Var X
			| Lam X Exp
			| App Exp Exp
			| Clo Exp Gam
			| Lamc X Exp Gam
			deriving(Eq, Show)
		
-- Defenition of context and closures
data Gam = Nil
			| Cont X Exp Gam
			deriving(Eq, Show)

-- Trim a string
trim xs = dropSpaceTail "" $ dropWhile isSpace xs

dropSpaceTail maybeStuff "" = ""
dropSpaceTail maybeStuff (x:xs)
        | isSpace x = dropSpaceTail (x:maybeStuff) xs
        | null maybeStuff = x : dropSpaceTail "" xs
        | otherwise       = reverse maybeStuff ++ x : dropSpaceTail "" xs
		
-- Parsing functions
		
extractString :: X -> (X, X)								-- Parse a string
extractString = head . spotWhile0 isLetter

extractVar :: X -> (Exp, X)									-- Parse a variable
extractVar prog = (Var x, rest) 
					where
					(x, rest) = extractString prog
					
extractLam :: X -> (Exp, X)								 	-- Parse a functions
extractLam prog = (Lam x e, rest)
					where
					(x, string) = extractString prog
					(e, rest) = extractExp $ tail string
					
extractApp :: X -> (Exp, X)									-- Parse a application
extractApp prog = (App e1 e2, tail rest) where
					(e1, string) = extractExp prog
					(e2, rest) = extractExp $ tail string

extractExp :: X -> (Exp, X)									-- Parse a expression
extractExp (h : t)
				| h == '\\' = extractLam t
				| h == '(' = extractApp t
				| h == '=' = extractExp t
				| otherwise = extractVar (h : t)
extractExp "" = (Var "", "") 

extract :: [X] -> [(X, Exp)]								-- General Parsing
extract (line : lines) =
						case rest of
							"" -> case string of
								"" -> [("", Var x)] ++ (extract lines)
								_ -> [(x, e)] ++ (extract lines)
							_ -> error "Parsing error"
						where
							prog = trim line
							(x, string) = extractString prog
							(e, rest) = extractExp string
extract _ = []		


showExp :: (X,Exp) -> X
showExp (a, b) = show b

crunch :: X -> X
crunch = unlines . map showExp . extract . lines

parseProgram file = (readFile file) >>= putStr . crunch