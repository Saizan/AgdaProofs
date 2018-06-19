{-# OPTIONS --cubical #-}
module omega where

  open import Cubical
  open import Agda.Builtin.Nat
  open import Cubical.PathPrelude
  open import Cubical.Lemmas

  Ω : (A : Set) → (a : A) → Set
  Ω A a = (a ≡ a)

  Ω² : (A : Set) → (a : A) → Set
  Ω² A a = Ω (a ≡ a) (refl {x = a}) -- (refl {x = a}) ≡ (refl {x = a})

  -- Proof of α · β = β · α where · is trans.

  infix 9 _·ᵣ_
  infix 9 _·ₗ_

  -- The sym part is to stay consistent with Hott's notations
  ru : {A : Set} → {x y : A} → (p : x ≡ y) → p ≡ trans p refl
  ru p = sym (trans-id p)

  --ruBase : {A : Set} {a : A} → (ru (refl {x = a})) ≡ refl {x = refl {x = a}}
  --ruBase = ?

  rBaseCase : {A : Set} → {a b : A} → {p q : (a ≡ b)} → {α : (p ≡ q)} → (trans p refl) ≡ (trans q refl)
  rBaseCase {A} {a} {b} {p} {q} {α} = (trans (sym (ru p)) (trans α (ru q)))

  rPType : {A : Set} {a b : A} (p q : (a ≡ b)) (c : A) (r : b ≡ c) → Set
  rPType p q = (λ c₁ r₁ → (trans p r₁) ≡ (trans q r₁))


  _·ᵣ_ : {A : Set} {a b : A} {p q : (a ≡ b)} {c : A} (α : (p ≡ q)) (r : (b ≡ c)) → (trans p r) ≡ (trans q r)
    
  _·ᵣ_ {A} {a} {b} {p} {q} {c} α r = pathJ 
    (rPType p q)
    rBaseCase
    c
    r

  -- Now equalities obtanied by paht induction aren't definitional anymore. We must thus create a lemma.

  rInit : {A : Set} {a b : A} {p q : (a ≡ b)} (α : (p ≡ q)) → (α ·ᵣ refl) ≡ (rBaseCase {α = α})

  rInit {A} {a} {b} {p} {q} α = λ i → pathJprop ((rPType p q)) rBaseCase i


{--

  Tryin prove and undeerstand pathJProp ?

  rInit : {A : Set} → {a b : A} → {p q : (a ≡ b)} → (α : (p ≡ q)) → (α ·ᵣ refl) ≡ (rBaseCase {α = α})
  rInit  {A} {a} {b} {p} {q} α =
    pathJ
    (λ q₁ α₁ → {!(α₁ ·ᵣ refl) ≡ (rBaseCase {α = α₁})!})
    refl
    q
    α
--}


  lu : {A : Set} → {x y : A} → (p : x ≡ y) → p ≡ trans refl p
  lu p = sym (trans-id-l p)

  lBaseCase : {A : Set} {b c : A} {r s : (b ≡ c)} {β : (r ≡ s)} → (trans refl r) ≡ (trans refl s)
  lBaseCase {A} {b} {c} {r} {s} {β} = ((trans (sym (lu r)) (trans β (lu s))))

  lPType :  {A : Set} {b c : A} (r s : (b ≡ c)) (a : A) (q : b ≡ a) → Set
  lPType r s = (λ a₁ q₁ → (trans (sym q₁) r) ≡ (trans (sym q₁) s))
  
  _·ₗ_ : {A : Set} → {a b c : A} → {r s : (b ≡ c)} → (q : (a ≡ b)) → (β : (r ≡ s)) → (trans q r) ≡ (trans q s)

  -- We must take the sym because the induction is based! So the sides doesn't play a symmetrical role.
  _·ₗ_ {A} {a} {b} {c} {r} {s} q β = pathJ
    (lPType r s)
    lBaseCase
    a
    (sym q)

  lInit : {A : Set} {b c : A} {r s : (b ≡ c)} (β : (r ≡ s)) → (refl ·ₗ β) ≡ (lBaseCase {β = β})

  lInit {A} {b} {c} {r} {s} β = λ i → pathJprop ((lPType r s)) lBaseCase i
  

  -- ⋆g is a more general operator, not ⋆ wich is only in Ω.
  
  infix 8 _⋆g_
  infix 8 _⋆_
  
  _⋆g_ : {A : Set} {a : A} {b : A} {c : A} {p q : (a ≡ b)} {r s : (b ≡ c)} (α : (p ≡ q)) (β : (r ≡ s)) → (trans p r) ≡ (trans q s)

  _⋆g_ {A} {a} {b} {c} {p} {q} {r} {s} α β = trans (α ·ᵣ r) (q ·ₗ β)

  lemma1 : {A : Set} (a : A) → trans (λ _ → a) (λ _ → a) ≡ (λ _ → a)
  lemma1 a = trans-id-l refl

  {-- Unused
  lemmam : {A : Set} {x y : A} (x ≡ y) → (x ≡ x) ≡ (y ≡ y)
  lemmam {A} {x} {y} p = pathJ
    (λ y₁ p₁ → (x ≡ x) ≡ (y₁ ≡ y₁))
    ( refl { x = (x ≡ x) } )
    y
    p
  --}

  -- We now show equality on the two desired types.
  familRefl :  {A : Set} (x : A) → Set
  familRefl = λ x → (x ≡ x)

  lemma2 : {A : Set} (a : A) → (trans (λ _ → a) (λ _ → a) ≡ trans (λ _ → a) (λ _ → a) ) ≡ ( (λ _ → a) ≡ (λ _ → a) )
  
  lemma2 a = cong familRefl ((lemma1 a))


  -- Now α ⋆ β and α · β doesn't live in the same world. So we have to transport one in the other somehow to somewhat achieve an equality.
  -- This is done in CTT by using PathP
  -- PathP is the 'same' as using transport:
  {-- e : A, e' : A', p: A ≡ A'
    transport p e ≡ e' <-> PathP [λi. A'] (transport p e) e'
  --}
  
  --starOnLoop : {A : Set} → {a : A} → (α β : (Ω² A a)) → PathP (λ i → (lemma2 a i)) (α ⋆ β) (trans α β)

  -- The problem is we want to use a simpler syntax for proof, that works only for homogeneous path. So we're going t have to stay with transport.
  
  p = λ a → (λ i → lemma2 a i)

  module _ {A : Set} {a : A} (α β : (Ω² A a)) where

    _⋆_ : (Ω² A a)
    _⋆_ = transp (p a) (α ⋆g β)

  module _ (A : Set) (a : A) (α β : (Ω² A a)) where

    -- We thus define obj wich is what we want to study
    pt = (p a)

    infix 3 _∙_
    _∙_ : {A : Set} {x y z : A} → x ≡ y → y ≡ z → x ≡ z
    a ∙ b = trans a b

    -- ? ≡⟨ ? ⟩ ?
    starOnLoop : (α ⋆ β) ≡ (α ∙ β)
    starOnLoop = begin
      (α ⋆ β) ≡⟨ cong (transp pt) (begin -- We do equalities under the transportation
          α ⋆g β ≡⟨⟩ --Definitional equality
         (α ·ᵣ refl) ∙ (refl ·ₗ β) ≡⟨ cong (λ x → trans x _) (rInit α) ⟩
         (rBaseCase) ∙ (refl ·ₗ β) ≡⟨  cong ((λ x → trans _ x)) ((lInit β)) ⟩
         (rBaseCase) ∙ (lBaseCase) ≡⟨⟩
         ((sym (ru refl) ∙ (α ∙ (ru refl))) ∙ ((sym (lu refl)) ∙ (β ∙(lu refl))))∎
         
         -- We would like to say (ru (refl {x = a})) ≡ refl {x = refl {x = a}}
         -- They unfortunately aren't of the same types : (λ _ → a) ≡ trans (λ _ → a) refl || (λ _ → a) ≡ (λ _ → 
        )⟩
      {!((sym (ru refl) ∙ (α ∙ (ru refl))) ∙ ((sym (lu refl)) ∙ (β ∙(lu refl))))!} ≡⟨ {!!} ⟩
      {!!} ≡⟨ {!!} ⟩
      (α ∙ β)∎

{-- 
 obj ≡⟨ cong (transp p) (begin 
        α ⋆ β ≡⟨ _ ⟩ --By definition
        trans (α ·ᵣ refl) (refl ·ₗ β) ≡⟨ {! (rInit α)!} ⟩
        {!trans (rBaseCase) (refl ·ₗ β)!} ≡⟨ {!!} ⟩
        {!!})
       ⟩

--}

  -- comm : {A : Set} → {a : A} → ( α β : (Ω² A a)) → (trans α β) ≡ (trans β α)
  -- comm = 
  
{--

    -- ? ≡⟨ ? ⟩ ?
    starOnLoop : (α ⋆ β) ≡ (α ∙ β)
    starOnLoop = begin
      (α ⋆ β) ≡⟨ cong (transp p) (begin -- We do equalities under the transportation
          α ⋆ β ≡⟨⟩ --Definitional equality
         (α ·ᵣ refl) ∙ (refl ·ₗ β) ≡⟨ cong (λ x → trans x _) (rInit α) ⟩
         (rBaseCase) ∙ (refl ·ₗ β) ≡⟨  cong ((λ x → trans _ x)) ((lInit β)) ⟩
         (rBaseCase) ∙ (lBaseCase) ≡⟨⟩
         ((sym (ru refl) ∙ (α ∙ (ru refl))) ∙ ((sym (lu refl)) ∙ (β ∙(lu refl))))∎
         
         -- We would like to say (ru (refl {x = a})) ≡ refl {x = refl {x = a}}
         -- They unfortunately aren't of the same types : (λ _ → a) ≡ trans (λ _ → a) refl || (λ _ → a) ≡ (λ _ → 
        )⟩
      transp p (((sym (ru refl) ∙ (α ∙ (ru refl))) ∙ ((sym (lu refl)) ∙ (β ∙(lu refl))))) ≡⟨ {!α ⋆ β!} ⟩
      {!!} ≡⟨ {!!} ⟩
      (α ∙ β) ∎

--}
