import Mathlib.Probability.IdentDistrib

/- To move close to Set.Finite.measurableSet-/
lemma Set.Finite.MeasurableSet
    {α : Type*} [MeasurableSpace α] [MeasurableSingletonClass α] {s : Set α} (hs : s.Finite) :
    MeasurableSet s :=
  hs.countable.measurableSet

/- To move close to Set.Finite.measurableSet-/
lemma measurableSet_of_countable {α : Type*} [MeasurableSpace α] [MeasurableSingletonClass α]
    [Countable α] (s : Set α) : MeasurableSet s :=
  s.to_countable.measurableSet

/- To move close to Set.Finite.measurableSet
  Should this sort of thing be implied by some kind of class for
  `MeasurableSpace`s with measure algebra `⊤`?
  -/
instance {α : Type*} [MeasurableSpace α] [MeasurableSingletonClass α] [Sub α]
    [Countable α] : MeasurableSub₂ α :=
  ⟨measurable_of_countable _⟩

/- To move close to Set.Finite.measurableSet
  Should this sort of thing be implied by some kind of class for
  `MeasurableSpace`s with measure algebra `⊤`?
  -/
instance {α : Type*} [MeasurableSpace α] [MeasurableSingletonClass α] [Add α]
    [Countable α] : MeasurableAdd₂ α :=
  ⟨measurable_of_countable _⟩

section

open Set

lemma Nat.card_eq_finset_card {α : Type*} {s : Finset α} : Nat.card s = s.card := by
  simp only [Nat.card_eq_fintype_card, Fintype.card_coe]

lemma Nat.card_eq_toFinset_card {α : Type*} {s : Set α} (hs : s.Finite) :
    Nat.card s = hs.toFinset.card := by
  simp only [← Nat.card_eq_finset_card, Finite.mem_toFinset]

end

section

open Set MeasureTheory Measure

lemma measure_preimage_eq_zero_iff_of_countable {Ω : Type*} {S : Type*} [MeasurableSpace Ω]
    {H : Set S} {X : Ω → S} {μ : Measure Ω} (hs : H.Countable) :
    μ (X ⁻¹' H) = 0 ↔ ∀ x ∈ H, μ (X ⁻¹' {x}) = 0 := by
  have : Countable H := countable_coe_iff.mpr hs
  refine ⟨fun h x hx ↦ ?_, fun h ↦ ?_⟩
  · apply le_antisymm ((measure_mono _).trans h.le) (zero_le _)
    apply preimage_mono
    simp [hx]
  · apply le_antisymm _ (zero_le _)
    calc
    μ (X ⁻¹' H) = μ (⋃ x : H, X ⁻¹' {(x : S)}) := by simp
    _ ≤ ∑' x : H, μ (X ⁻¹' {(x : S)}) := measure_iUnion_le _
    _ = ∑' x : H, 0 := by congr with x; exact h x x.2
    _ = 0 := by simp

end

section

open scoped BigOperators

variable [CommMonoid β]

@[to_additive]
theorem Finset.prod_finset_eq_prod [Fintype α] {s : Finset α} {f : α → β}
    (h : ∀ i ∉ s, f i = 1) :
    ∏ i in s, f i = ∏ i, f i := by
  classical
  have : ∏ i in sᶜ, f i = 1 := Finset.prod_eq_one (fun i hi ↦ h i (Finset.mem_compl.mp hi))
  rw [← Finset.prod_mul_prod_compl s f, this, mul_one]

end

section

-- Move to be near `AddMonoidHom.map_sub`, make multiplicative and additive versions
@[simp] lemma AddMonoidHom.comp_sub
    {α : Type*} {H : Type*} {H' : Type*} [AddCommGroup H] [AddCommGroup H']
    (π : H →+ H') (X Y : α → H) :
    π ∘ (X - Y) = π ∘ X - π ∘ Y := by
  ext
  simp
