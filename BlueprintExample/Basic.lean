
/-!
# Example
This is a simple property on ℕ
-/

/-!
Takes the first natural numbers and sum them
-/
def sum_until: Nat → Nat
| 0 => 0
| n + 1 => Nat.succ n + sum_until n

#eval sum_until 5

theorem sum_first_natural_numbers: ∀ n : Nat, 2 * (sum_until n) = n * (n + 1) :=
by
  intro n
  induction n with
  | zero => grind [sum_until]
  | succ n ih => grind [sum_until]
