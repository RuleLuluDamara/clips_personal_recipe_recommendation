(deftemplate Recipe
    (slot recipe)
    (slot cuisine)
    (slot difficulty)
    (slot ingredients)
    (slot instructions)
    (slot budget)
    (slot vegetarian) 
    (slot rating (type INTEGER) (default 0))
)

(deftemplate User
    (slot name)
    (slot cuisine-pref)
    (slot difficulty-pref)
    (slot ingredients-pref)
    (slot vegetarian-pref) 
    (slot budget-pref)
    (slot rated (type SYMBOL) (default no))
)

(defrule GetUserPreferences
    (not (User (name ?name)))
    =>
    (printout t "insert your name !")
    (bind ?name (read))
    (printout t "Welcome, " ?name ". Let's find you a recipe!" crlf)
    (printout t "What cuisine do you prefer? ")
    (bind ?cuisine-pref (read))
    (printout t "How difficult should the recipe be? (Easy, Intermediate, Difficult) ")
    (bind ?difficulty-pref (read))
    (printout t "Do you have any specific ingredient preferences? ")
    (bind ?ingredients-pref (read))
    (printout t "Do you prefer vegetarian or non-vegetarian recipes?(yes/no) ")
    (bind ?vegetarian-pref (read)) ; Menambahkan preferensi kategori
    (printout t "How Much is your budget? (range 15000-40000)")
    (bind ?budget-pref (read))
    (assert (User 
        (name ?name)
        (difficulty-pref ?difficulty-pref)
        (cuisine-pref ?cuisine-pref)
        (ingredients-pref ?ingredients-pref)
        (vegetarian-pref ?vegetarian-pref) 
        (budget-pref ?budget-pref)
    ))

)

(defrule RecommendRecipe-cuisine
    (User
        (name ?name)
        (cuisine-pref ?cuisine-pref)
    )

    (Recipe
        (recipe ?recipe)
        (cuisine ?cuisine)
        (difficulty ?difficulty)
        (ingredients ?ingredients)
        (instructions ?instructions)
        (budget ?budget)
    )

    (test (eq ?cuisine ?cuisine-pref))

    =>
    (printout t "Based on your cuisine preferences, we recommend: " ?recipe crlf)
    (printout t "Cuisine: " ?cuisine crlf)
    (printout t "Difficulty: " ?difficulty crlf)
    (printout t "Ingredients: " ?ingredients crlf)
    (printout t "Instructions: " ?instructions crlf)
    (printout t "Budget: " ?budget crlf)
    (printout t "Budget: " ?budget crlf)
    (printout t "Enjoy your meal!" crlf crlf)
)

(defrule RecommendRecipe-difficulty
    (User
        (name ?name)
        (difficulty-pref ?difficulty-pref)
    )

    (Recipe
        (recipe ?recipe)
        (cuisine ?cuisine)
        (difficulty ?difficulty)
        (ingredients ?ingredients)
        (instructions ?instructions)
        (budget ?budget)
    )

    (test (eq ?difficulty ?difficulty-pref))
    =>
    (printout t "Based on your difficulty preferences, we recommend: " ?recipe crlf)
    (printout t "Cuisine: " ?cuisine crlf)
    (printout t "Difficulty: " ?difficulty crlf)
    (printout t "Ingredients: " ?ingredients crlf)
    (printout t "Instructions: " ?instructions crlf)
    (printout t "Budget: " ?budget crlf)
    (printout t "Enjoy your meal!" crlf crlf)
)

(defrule RecommendRecipe-ingredients
    (User
        (name ?name)
        (ingredients-pref ?ingredients-pref)
    )

    (Recipe
        (recipe ?recipe)
        (cuisine ?cuisine)
        (difficulty ?difficulty)
        (ingredients ?ingredients)
        (instructions ?instructions)
        (budget ?budget)
    )

    (test (str-compare ?ingredients ?ingredients-pref))

    =>
    (printout t "Based on your ingredient preferences, we recommend: " ?recipe crlf)
    (printout t "Cuisine: " ?cuisine crlf)
    (printout t "Difficulty: " ?difficulty crlf)
    (printout t "Ingredients: " ?ingredients crlf)
    (printout t "Instructions: " ?instructions crlf)
    (printout t "Budget: " ?budget crlf)
    (printout t "Enjoy your meal!" crlf crlf)
)

(defrule RecommendRecipe-budget
    (User
        (name ?name)
        (budget-pref ?budget-pref)
    )

    (Recipe
        (recipe ?recipe)
        (cuisine ?cuisine)
        (difficulty ?difficulty)
        (ingredients ?ingredients)
        (instructions ?instructions)
        (vegetarian ?vegetarian)
        (budget ?budget)
    )

    (test (<= ?budget ?budget-pref))

    =>
    (printout t "Based on your budget preferences, we recommend: " ?recipe crlf)
    (printout t "Cuisine: " ?cuisine crlf)
    (printout t "Difficulty: " ?difficulty crlf)
    (printout t "Ingredients: " ?ingredients crlf)
    (printout t "Instructions: " ?instructions crlf)
    (printout t "vegetarian: " ?vegetarian crlf)
    (printout t "Budget: " ?budget crlf)
    (printout t "Enjoy your meal!" crlf crlf)
)

(defrule RateRecipe
    (User
        (name ?name)
        (rated yes) ; Pastikan pengguna telah memberikan rating
    )
    (Recipe
        (recipe ?recipe)
        (rating 0) ; Pastikan hanya merating resep yang belum mendapatkan rating
    )

    =>
    (printout t "You have rated " ?recipe ". Please rate this recipe (1-5): ")
    (bind ?user-rating (read))
    (bind ?new-rating (if (and (<= ?user-rating 1) (<= ?user-rating 5))
        then
        ?user-rating
        else
        5))
    (modify ?recipe (rating ?new-rating))
)

(deffunction GiveRating (?rating)
    (if (and (<= ?rating 5) (>= ?rating 1))
        then
        (printout t "Thank you for your rating: " ?rating " out of 5. We appreciate your feedback!" crlf)
    else
        (printout t "Invalid rating. Please provide a rating between 1 and 5." crlf)
    )
)

(deffunction GoodbyeMessage ()
   (printout t "Goodbye and thank you for using this system!" crlf)
)

(defrule StartRating
   =>
   (printout t "Please enter your rating (1 to 5): ")
   (bind ?rating (read))
   (GiveRating ?rating)
   (GoodbyeMessage)
   (halt)
)

(defrule RecommendRecipe-vegetarian
    (User
        (name ?name)
        (vegetarian-pref ?vegetarian-pref)
    )

    (Recipe
        (recipe ?recipe)
        (cuisine ?cuisine)
        (difficulty ?difficulty)
        (ingredients ?ingredients)
        (instructions ?instructions)
        (vegetarian ?vegetarian)        
        (budget ?budget)
    )

    (test (eq ?vegetarian ?vegetarian-pref))
    =>
    (printout t "Based on your difficulty preferences, we recommend: " ?recipe crlf)
    (printout t "Cuisine: " ?cuisine crlf)
    (printout t "Difficulty: " ?difficulty crlf)
    (printout t "Ingredients: " ?ingredients crlf)
    (printout t "Instructions: " ?instructions crlf)
    (printout t "vegetarian: " ?vegetarian crlf)
    (printout t "Budget: " ?budget crlf)
    (printout t "Enjoy your meal!" crlf crlf)
)

(deftemplate RecipeComment
  (slot comment (type STRING))
)

(deffunction SaveComment (?comment)
   (assert (RecipeComment (comment ?comment)))
   (printout t "Thank you for your comment: " ?comment crlf)
)


(defrule StartComment
   =>
   (printout t "Please give us one word that sum up ur feeling: ")
   (bind ?comment (read))
   (SaveComment ?comment)
   (GoodbyeMessage)
   (halt)
)


(deffacts SampleRecipes
    (Recipe 
        (recipe "Spaghetti Carbonara") 
        (cuisine "Italian") 
        (difficulty "Easy")
        (ingredients "spaghetti, eggs, bacon, parmesan cheese") 
        (instructions "1. Cook spaghetti. 2. Fry bacon. 3. Mix eggs and cheese. 4. Toss with pasta.")
        (budget 40000)
        (vegetarian no) ; Tidak vegetarian
    )

    (Recipe 
        (recipe "Chicken Tikka Masala") 
        (cuisine "Indian") 
        (difficulty "Intermediate")
        (ingredients "chicken, yogurt, tomato sauce, spices") 
        (instructions "1. Marinate chicken. 2. Cook chicken. 3. Simmer in sauce.")
        (budget 35000)
        (vegetarian no) ; Tidak vegetarian
    )

    (Recipe 
        (recipe "Caesar Salad") 
        (cuisine "American") 
        (difficulty "Easy")
        (ingredients "romaine lettuce, croutons, caesar dressing") 
        (instructions "1. Toss lettuce with dressing. 2. Add croutons.")
        (budget 35000)
        (vegetarian yes) ; Vegetarian
    )

    (Recipe 
        (recipe "Nasi Goreng")
        (cuisine "Indonesian") 
        (difficulty "Intermediate")
        (ingredients "cooked rice, shallots, garlic, kecap manis, soy sauce, chili, prawns, chicken, eggs, vegetables") 
        (instructions "1. Heat oil and sauté chopped garlic and shallots. 2. Add diced chicken and prawns, and cook until they change color. 3. Push the chicken and prawns to one side and crack eggs into the pan. Scramble the eggs. 4. Add diced chili and vegetables. 5. Add the cooked rice, kecap manis, and soy sauce. 6. Stir-fry until everything is well mixed. 7. Serve hot and garnish as desired.")
        (budget 30000)
        (vegetarian no) ; Tidak vegetarian
    )
    
    (Recipe 
        (recipe "Gado-Gado")
        (cuisine "Indonesian")
        (difficulty "Easy")
        (ingredients "vegetables, peanut sauce, tofu, tempeh, boiled eggs, rice cake, prawn crackers")
        (instructions "1. Arrange vegetables, tofu, tempeh, and boiled eggs on a plate. 2. Pour peanut sauce over them. 3. Serve with rice cake and prawn crackers.")
        (budget 30000)
        (vegetarian yes) ; Vegetarian
    )

    (Recipe 
        (recipe "Sate Ayam")
        (cuisine "Indonesian")
        (difficulty "Easy")
        (ingredients "chicken skewers, peanut sauce, shallots, garlic, lemongrass, soy sauce, kaffir lime leaves")
        (instructions "1. Marinate chicken skewers. 2. Grill until cooked. 3. Serve with peanut sauce.")     
        (budget 20000)
        (vegetarian no) ; Tidak vegetarian
    )

    (Recipe
        (recipe "Nasi Padang")
        (cuisine "Indonesian")
        (difficulty "Difficult")
        (ingredients "steamed rice, various side dishes, rendang, sambal, cassava leaves, coconut milk")
        (instructions "1. Serve steamed rice with an array of side dishes. 2. Include rendang, sambal, cassava leaves, and coconut milk.")
        (budget 30000)
        (vegetarian no) ; Tidak vegetarian
    )

    (Recipe
        (recipe "Mie Ayam")
        (cuisine "Indonesian")
        (difficulty "Intermediate")
        (ingredients "egg noodles, chicken, mushrooms, bok choy, fried shallots, garlic, soy sauce")
        (instructions "1. Cook egg noodles. 2. Prepare chicken, mushrooms, and bok choy. 3. Combine with fried shallots, garlic, and soy sauce.")
        (budget 20000)
        (vegetarian no) ; Tidak vegetarian
    )

    (Recipe
        (recipe "Pecel Lele")
        (cuisine "Indonesian")
        (difficulty "Easy")
        (ingredients "fried catfish, rice, vegetable salad, peanut sauce, fried tempeh, sambal")
        (instructions "1. Serve fried catfish with rice and vegetable salad. 2. Drizzle with peanut sauce and serve with fried tempeh and sambal.")
        (budget 15000)
        (vegetarian no) ; Tidak vegetarian
    )

    (Recipe
        (recipe "Nasi Tumpeng")
        (cuisine "Indonesian")
        (difficulty "Intermediate")
        (ingredients "yellow rice cone, various side dishes, fried chicken, egg, vegetables, coconut milk")
        (instructions "1. Prepare a yellow rice cone. 2. Serve with an array of side dishes including fried chicken, egg, vegetables, and coconut milk.")
        (budget 35000)
        (vegetarian no) ; Tidak vegetarian
    )

    (Recipe
        (recipe "Sambal Goreng Ati")
        (cuisine "Indonesian")
        (difficulty "Intermediate")
        (ingredients "chicken liver, gizzard, sambal, coconut milk, tamarind")
        (instructions "1. Cook chicken liver and gizzard with sambal, coconut milk, and tamarind.")
        (budget 25000)
        (vegetarian no) ; Tidak vegetarian
    )
)
