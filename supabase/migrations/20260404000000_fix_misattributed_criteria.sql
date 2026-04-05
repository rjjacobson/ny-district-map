-- Fix misattributed person_criteria records
BEGIN;

-- Delete duplicates and conflict records
DELETE FROM person_criteria WHERE id IN (109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 134, 135, 137, 138, 139, 140, 141, 142, 144, 145, 147, 148, 150, 151, 152, 153, 154, 155, 156, 157, 158, 167, 97, 101, 102, 103, 105, 307, 308, 279, 311, 312, 313, 314, 122, 133, 136, 159, 163, 168, 171, 172, 173, 174, 175, 177, 178, 316, 317, 318, 319, 322, 323, 326, 342, 348, 353, 354, 357, 361, 379, 382, 384, 385, 387, 389, 391, 392, 393, 394, 395, 396, 397, 398, 399, 400, 402, 403, 406);

-- Reassign evidence to correct person
UPDATE person_criteria SET person_id = 87 WHERE id = 94; -- Stacey Pheffer Amato -> David I. Weprin
UPDATE person_criteria SET person_id = 89 WHERE id = 99; -- Nily Rozic -> Edward C. Braunstein
UPDATE person_criteria SET person_id = 91 WHERE id = 104; -- Edward C. Braunstein -> Andrew Hevesi
UPDATE person_criteria SET person_id = 97 WHERE id = 106; -- Sam Berger -> Jessica Gonzalez-Rojas
UPDATE person_criteria SET person_id = 97 WHERE id = 107; -- Sam Berger -> Jessica Gonzalez-Rojas
UPDATE person_criteria SET person_id = 99 WHERE id = 108; -- Andrew Hevesi -> Diana C. Moreno
UPDATE person_criteria SET person_id = 166 WHERE id = 143; -- Karen McMahon -> Sarahana Shrestha
UPDATE person_criteria SET person_id = 265 WHERE id = 146; -- Harvey Epstein -> Chuck Schumer
UPDATE person_criteria SET person_id = 115 WHERE id = 149; -- Julie Menin -> Jo Anne Simon
UPDATE person_criteria SET person_id = 130 WHERE id = 160; -- Kevin C. Riley -> Linda B. Rosenthal
UPDATE person_criteria SET person_id = 132 WHERE id = 161; -- Pierina Ana Sanchez -> Micah C. Lasher
UPDATE person_criteria SET person_id = 135 WHERE id = 162; -- Althea Stevens -> Manny De Los Santos
UPDATE person_criteria SET person_id = 137 WHERE id = 164; -- Tiffany Caban -> Keith Powers
UPDATE person_criteria SET person_id = 137 WHERE id = 165; -- Tiffany Caban -> Keith Powers
UPDATE person_criteria SET person_id = 138 WHERE id = 166; -- Tiffany Caban -> Tony Simone
UPDATE person_criteria SET person_id = 224 WHERE id = 170; -- Julie Won -> Eric Dinowitz
UPDATE person_criteria SET person_id = 151 WHERE id = 176; -- Lincoln Restler -> Amy Paulin
UPDATE person_criteria SET person_id = 157 WHERE id = 179; -- Jennifer Gutierrez -> Matt Slater
UPDATE person_criteria SET person_id = 157 WHERE id = 180; -- Crystal Hudson -> Matt Slater
UPDATE person_criteria SET person_id = 158 WHERE id = 181; -- Chi Osse -> Dana Levenberg
UPDATE person_criteria SET person_id = 158 WHERE id = 182; -- Chi Osse -> Dana Levenberg
UPDATE person_criteria SET person_id = 161 WHERE id = 183; -- Chi Osse -> Karl Brabenec
UPDATE person_criteria SET person_id = 161 WHERE id = 184; -- Sandy Nurse -> Karl Brabenec
UPDATE person_criteria SET person_id = 151 WHERE id = 315; -- Chuck Schumer -> Amy Paulin
UPDATE person_criteria SET person_id = 158 WHERE id = 320; -- Kirsten Gillibrand -> Dana Levenberg
UPDATE person_criteria SET person_id = 160 WHERE id = 321; -- Kirsten Gillibrand -> Aron Wieder
UPDATE person_criteria SET person_id = 164 WHERE id = 324; -- Nick LaLota -> Brian Maher
UPDATE person_criteria SET person_id = 166 WHERE id = 325; -- Nick LaLota -> Sarahana Shrestha
UPDATE person_criteria SET person_id = 169 WHERE id = 327; -- Andrew Garbarino -> Didi Barrett
UPDATE person_criteria SET person_id = 172 WHERE id = 328; -- Andrew Garbarino -> Gabriella A. Romero
UPDATE person_criteria SET person_id = 175 WHERE id = 329; -- Andrew Garbarino -> Mary Beth Walsh
UPDATE person_criteria SET person_id = 180 WHERE id = 330; -- Tom Suozzi -> Ken Blankenbush
UPDATE person_criteria SET person_id = 184 WHERE id = 331; -- Tom Suozzi -> Joe Angelino
UPDATE person_criteria SET person_id = 185 WHERE id = 332; -- Tom Suozzi -> Brian D. Miller
UPDATE person_criteria SET person_id = 187 WHERE id = 333; -- Tom Suozzi -> Christopher S. Friend
UPDATE person_criteria SET person_id = 188 WHERE id = 334; -- Laura Gillen -> Dr. Anna R. Kelles
UPDATE person_criteria SET person_id = 195 WHERE id = 335; -- Laura Gillen -> Philip A. Palmesano
UPDATE person_criteria SET person_id = 197 WHERE id = 336; -- Laura Gillen -> Josh Jensen
UPDATE person_criteria SET person_id = 198 WHERE id = 337; -- Laura Gillen -> Jen Lunsford
UPDATE person_criteria SET person_id = 202 WHERE id = 338; -- Gregory Meeks -> Stephen Hawley
UPDATE person_criteria SET person_id = 210 WHERE id = 339; -- Gregory Meeks -> David DiPietro
UPDATE person_criteria SET person_id = 214 WHERE id = 340; -- Gregory Meeks -> Christopher Marte
UPDATE person_criteria SET person_id = 214 WHERE id = 341; -- Grace Meng -> Christopher Marte
UPDATE person_criteria SET person_id = 246 WHERE id = 343; -- Grace Meng -> Lincoln Restler
UPDATE person_criteria SET person_id = 218 WHERE id = 344; -- Nydia Velazquez -> Julie Menin
UPDATE person_criteria SET person_id = 218 WHERE id = 345; -- Nydia Velazquez -> Julie Menin
UPDATE person_criteria SET person_id = 218 WHERE id = 346; -- Hakeem Jeffries -> Julie Menin
UPDATE person_criteria SET person_id = 219 WHERE id = 347; -- Hakeem Jeffries -> Gale A. Brewer
UPDATE person_criteria SET person_id = 219 WHERE id = 349; -- Hakeem Jeffries -> Gale A. Brewer
UPDATE person_criteria SET person_id = 222 WHERE id = 350; -- Yvette Clarke -> Yusef Salaam
UPDATE person_criteria SET person_id = 223 WHERE id = 351; -- Yvette Clarke -> Carmen De La Rosa
UPDATE person_criteria SET person_id = 224 WHERE id = 352; -- Dan Goldman -> Eric Dinowitz
UPDATE person_criteria SET person_id = 230 WHERE id = 355; -- Nicole Malliotakis -> Justin Sanchez
UPDATE person_criteria SET person_id = 229 WHERE id = 356; -- Nicole Malliotakis -> Althea Stevens
UPDATE person_criteria SET person_id = 232 WHERE id = 358; -- Nicole Malliotakis -> Vickie Paladino
UPDATE person_criteria SET person_id = 236 WHERE id = 359; -- Nicole Malliotakis -> Linda Lee
UPDATE person_criteria SET person_id = 237 WHERE id = 360; -- Jerry Nadler -> James F. Gennaro
UPDATE person_criteria SET person_id = 238 WHERE id = 362; -- Jerry Nadler -> Shekar Krishnan
UPDATE person_criteria SET person_id = 242 WHERE id = 364; -- Adriano Espaillat -> Lynn Schulman
UPDATE person_criteria SET person_id = 245 WHERE id = 365; -- Alexandria Ocasio-Cortez -> Joann Ariola
UPDATE person_criteria SET person_id = 245 WHERE id = 366; -- Alexandria Ocasio-Cortez -> Joann Ariola
UPDATE person_criteria SET person_id = 246 WHERE id = 367; -- Alexandria Ocasio-Cortez -> Lincoln Restler
UPDATE person_criteria SET person_id = 249 WHERE id = 371; -- Ritchie Torres -> Chi Osse
UPDATE person_criteria SET person_id = 247 WHERE id = 368; -- Ritchie Torres -> Jennifer Gutierrez
UPDATE person_criteria SET person_id = 247 WHERE id = 369; -- Ritchie Torres -> Jennifer Gutierrez
UPDATE person_criteria SET person_id = 248 WHERE id = 370; -- Ritchie Torres -> Crystal Hudson
UPDATE person_criteria SET person_id = 251 WHERE id = 375; -- George Latimer -> Alexa Aviles
UPDATE person_criteria SET person_id = 249 WHERE id = 372; -- George Latimer -> Chi Osse
UPDATE person_criteria SET person_id = 250 WHERE id = 373; -- George Latimer -> Sandy Nurse
UPDATE person_criteria SET person_id = 252 WHERE id = 374; -- George Latimer -> Shahana Hanif
UPDATE person_criteria SET person_id = 251 WHERE id = 376; -- Mike Lawler -> Alexa Aviles
UPDATE person_criteria SET person_id = 252 WHERE id = 377; -- Mike Lawler -> Shahana Hanif
UPDATE person_criteria SET person_id = 252 WHERE id = 378; -- Mike Lawler -> Shahana Hanif
UPDATE person_criteria SET person_id = 253 WHERE id = 380; -- Mike Lawler -> Rita Joseph
UPDATE person_criteria SET person_id = 257 WHERE id = 381; -- Pat Ryan -> Simcha Felder
UPDATE person_criteria SET person_id = 260 WHERE id = 383; -- Josh Riley -> Kayla Santosuosso
UPDATE person_criteria SET person_id = 261 WHERE id = 386; -- Paul Tonko -> Inna Vernikov
UPDATE person_criteria SET person_id = 263 WHERE id = 388; -- Paul Tonko -> David Carr
UPDATE person_criteria SET person_id = 264 WHERE id = 390; -- Elise Stefanik -> Frank Morano
UPDATE person_criteria SET person_id = 267 WHERE id = 401; -- Claudia Tenney -> Nick LaLota

-- Additional manual fixes
UPDATE person_criteria SET person_id = 143 WHERE id = 169; -- Shekar Krishnan -> John Zaccaro, Jr.
UPDATE person_criteria SET person_id = 239 WHERE id = 363; -- Adriano Espaillat -> Julie Won
DELETE FROM person_criteria WHERE id IN (276, 299); -- exact duplicates

COMMIT;
