questions = Question.create!([
                               { description: '¿En qué año comenzó la Segunda Guerra Mundial?', event: 0 },
                               { description: '¿Qué evento desencadenó el inicio de la Segunda Guerra Mundial?', event: 0 },
                               { description: '¿Cuál fue el nombre del plan alemán para invadir la Unión Soviética?', event: 0 },
                               { description: '¿Qué país sufrió el primer ataque atómico durante la Segunda Guerra Mundial?', event: 0 },
                               { description: '¿Qué conferencia decidió el destino de la Alemania post-guerra?', event: 0 },
                               { description: '¿Quién fue el primer ministro británico durante la mayor parte de la Segunda Guerra Mundial?', event: 0 },
                               { description: '¿Qué fue la Batalla de Stalingrado?', event: 0 },
                               { description: '¿Qué países formaban parte de las Potencias del Eje?', event: 0 },
                               { description: '¿Qué fue el Día D y cuándo ocurrió?', event: 0 },
                               { description: '¿Quién fue el presidente de los Estados Unidos durante la mayor parte de la Segunda Guerra Mundial?', event: 0 },
                               { description: '¿Qué nombre recibió el proyecto estadounidense para desarrollar la bomba atómica?', event: 0 },
                               { description: '¿Cuál fue el avión caza más famoso utilizado por los británicos durante la Batalla de Inglaterra?', event: 0 },
                               { description: '¿Qué fue el Enigma?', event: 0 },
                               { description: '¿Qué tanque fue conocido como el "Tigre" en la Segunda Guerra Mundial?', event: 0 },
                               { description: '¿Quién fue el líder de la Unión Soviética durante la Segunda Guerra Mundial?', event: 0 },
                               { description: '¿Qué general estadounidense fue conocido por su liderazgo en el Teatro de Operaciones del Pacífico?', event: 0 },
                               { description: '¿Quién fue el líder de la Alemania Nazi durante la Segunda Guerra Mundial?', event: 0 },
                               { description: '¿Qué general alemán fue apodado el "Zorro del Desierto"?', event: 0 },
                               { description: '¿Cuál fue la conferencia en la que se discutió la rendición incondicional de Japón?', event: 0 },
                               { description: '¿Qué fue la "Gran Alianza"?', event: 0 },
                               { description: '¿Qué significan las siglas "RAF" en el contexto de la Segunda Guerra Mundial?', event: 0 },
                               { description: '¿Qué fue el Holocausto?', event: 0 },
                               { description: '¿En qué país comenzó la Revolución Industrial?', event: 1 },
                               { description: '¿En qué siglo comenzó la Revolución Industrial?', event: 1 },
                               { description: '¿Cuál fue una de las principales industrias que lideró la Revolución Industrial?', event: 1},
                               { description: '¿Quién inventó la máquina de vapor que impulsó la Revolución Industrial?', event: 1 },
                               { description: '¿Qué sistema de producción se hizo popular durante la Revolución Industrial?', event: 1 },
                               { description: '¿Qué fue la Ley de Cercamientos?', event: 1 },
                               { description: '¿Qué recurso natural fue fundamental para el desarrollo de la Revolución Industrial?', event: 1 },
                               { description: '¿Qué transporte se desarrolló significativamente durante la Revolución Industrial?', event: 1 }
                             ])

answers = Answer.create!([
                           { description: '1938', question: questions[0], is_correct: false },
                           { description: '1939', question: questions[0], is_correct: true },
                           { description: '1940', question: questions[0], is_correct: false },
                           { description: '1941', question: questions[0], is_correct: false },

                           { description: 'El ataque a Pearl Harbor', question: questions[1], is_correct: false },
                           { description: 'La invasión de Francia', question: questions[1], is_correct: false },
                           { description: 'La invasión de Polonia', question: questions[1], is_correct: true },
                           { description: 'El bombardeo de Londres', question: questions[1], is_correct: false },

                           { description: 'Operación Overlord', question: questions[2], is_correct: false },
                           { description: 'Operación Market Garden', question: questions[2], is_correct: false },
                           { description: 'Operación Barbarroja', question: questions[2], is_correct: true },
                           { description: 'Operación Torch', question: questions[2], is_correct: false },

                           { description: 'Alemania', question: questions[3], is_correct: false },
                           { description: 'Italia', question: questions[3], is_correct: false },
                           { description: 'China', question: questions[3], is_correct: false },
                           { description: 'Japón', question: questions[3], is_correct: true },

                           { description: 'Conferencia de Teherán', question: questions[4], is_correct: false },
                           { description: 'Conferencia de Yalta', question: questions[4], is_correct: true },
                           { description: 'Conferencia de Potsdam', question: questions[4], is_correct: false },
                           { description: 'Conferencia de Múnich', question: questions[4], is_correct: false },

                           { description: 'Neville Chamberlain', question: questions[5], is_correct: false },
                           { description: 'Clement Attlee', question: questions[5], is_correct: false },
                           { description: 'Winston Churchill', question: questions[5], is_correct: true },
                           { description: 'Anthony Eden', question: questions[5], is_correct: false },

                           { description: 'Una batalla naval en el Pacífico', question: questions[6], is_correct: false },
                           { description: 'Una batalla aérea sobre Gran Bretaña', question: questions[6], is_correct: false },
                           { description: 'Una batalla en el norte de África', question: questions[6], is_correct: false },
                           { description: 'Una batalla en el Frente Oriental', question: questions[6], is_correct: true },

                           { description: 'Alemania, Francia y Japón', question: questions[7], is_correct: false },
                           { description: 'Alemania, Italia y Japón', question: questions[7], is_correct: true },
                           { description: 'Alemania, Italia y China', question: questions[7], is_correct: false },
                           { description: 'Alemania, Rusia y Japón', question: questions[7], is_correct: false },

                           { description: 'La invasión de Polonia en 1939', question: questions[8], is_correct: false },
                           { description: 'La invasión de Francia en 1940', question: questions[8], is_correct: false },
                           { description: 'La invasión de Normandía en 1944', question: questions[8], is_correct: true },
                           { description: 'La rendición de Alemania en 1945', question: questions[8], is_correct: false },

                           { description: 'Harry S. Truman', question: questions[9], is_correct: false },
                           { description: 'Dwight D. Eisenhower', question: questions[9], is_correct: false },
                           { description: 'Herbert Hoover', question: questions[9], is_correct: false },
                           { description: 'Franklin D. Roosevelt', question: questions[9], is_correct: true },

                           { description: 'Proyecto Omega', question: questions[10], is_correct: false },
                           { description: 'Proyecto Manhattan', question: questions[10], is_correct: true },
                           { description: 'Proyecto Mercury', question: questions[10], is_correct: false },
                           { description: 'Proyecto Trinity', question: questions[10], is_correct: false },

                           { description: 'P-51 Mustang', question: questions[11], is_correct: false },
                           { description: 'Focke-Wulf Fw 190', question: questions[11], is_correct: false },
                           { description: 'Supermarine Spitfire', question: questions[11], is_correct: true },
                           { description: 'Messerschmitt Bf 109', question: questions[11], is_correct: false },

                           { description: 'Un submarino alemán', question: questions[12], is_correct: false },
                           { description: 'Un tanque británico', question: questions[12], is_correct: false },
                           { description: 'Una máquina de cifrado alemana', question: questions[12], is_correct: true },
                           { description: 'Un radar estadounidense', question: questions[12], is_correct: false },

                           { description: 'Panzer IV', question: questions[13], is_correct: false },
                           { description: 'Panther', question: questions[13], is_correct: false },
                           { description: 'Panzer VI Tiger', question: questions[13], is_correct: true },
                           { description: 'Sherman', question: questions[13], is_correct: false },

                           { description: 'Leon Trotsky', question: questions[14], is_correct: false },
                           { description: 'Nikita Khrushchev', question: questions[14], is_correct: false },
                           { description: 'Iósif Stalin', question: questions[14], is_correct: true },
                           { description: 'Vladimir Lenin', question: questions[14], is_correct: false },

                           { description: 'George S. Patton', question: questions[15], is_correct: false },
                           { description: 'Dwight D. Eisenhower', question: questions[15], is_correct: false },
                           { description: 'Omar Bradley', question: questions[15], is_correct: false },
                           { description: 'Douglas MacArthur', question: questions[15], is_correct: true },

                           { description: 'Heinrich Himmler', question: questions[16], is_correct: false },
                           { description: 'Hermann Göring', question: questions[16], is_correct: false },
                           { description: 'Joseph Goebbels', question: questions[16], is_correct: false },
                           { description: 'Adolf Hitler', question: questions[16], is_correct: true },

                           { description: 'Heinz Guderian', question: questions[17], is_correct: false },
                           { description: 'Erwin Rommel', question: questions[17], is_correct: true },
                           { description: 'Gerd von Rundstedt', question: questions[17], is_correct: false },
                           { description: 'Wilhelm Keitel', question: questions[17], is_correct: false },

                           { description: 'Conferencia de Casablanca', question: questions[18], is_correct: false },
                           { description: 'Conferencia de Teherán', question: questions[18], is_correct: false },
                           { description: 'Conferencia de Potsdam', question: questions[18], is_correct: true },
                           { description: 'Conferencia de Yalta', question: questions[18], is_correct: false },

                           { description: 'La alianza entre Alemania, Italia y Japón', question: questions[19], is_correct: false },
                           { description: 'La alianza entre Estados Unidos, el Reino Unido y la Unión Soviética', question: questions[19], is_correct: true },
                           { description: 'La alianza entre Francia, Reino Unido y Polonia', question: questions[19], is_correct: false },
                           { description: 'La alianza entre Estados Unidos, China y el Reino Unido', question: questions[19], is_correct: false },

                           { description: 'Royal Army Force', question: questions[20], is_correct: false },
                           { description: 'Royal Air Force', question: questions[20], is_correct: true },
                           { description: 'Russian Armed Forces', question: questions[20], is_correct: false },
                           { description: 'Reich Air Fleet', question: questions[20], is_correct: false },

                           { description: 'El bombardeo de Londres por Alemania', question: questions[21], is_correct: false },
                           { description: 'La invasión de Francia por las fuerzas aliadas', question: questions[21], is_correct: false },
                           { description: 'El genocidio perpetrado por el régimen nazi contra los judíos y otros grupos minoritarios', question: questions[21], is_correct: true },
                           { description: 'La guerra de guerrillas en el sudeste asiático', question: questions[21], is_correct: false },

                           { description: 'Francia', question: questions[22], is_correct: false },
                           { description: 'Estados Unidos', question: questions[22], is_correct: false },
                           { description: 'Alemania', question: questions[22], is_correct: false },
                           { description: 'Reino Unido', question: questions[22], is_correct: true },

                           { description: 'Siglo XVII', question: questions[23], is_correct: false },
                           { description: 'Siglo XVIII', question: questions[23], is_correct: true },
                           { description: 'Siglo XIX', question: questions[23], is_correct: false },
                           { description: 'Siglo XX', question: questions[23], is_correct: false },

                           { description: 'La industria textil', question: questions[24], is_correct: true },
                           { description: 'La industria automotriz', question: questions[24], is_correct: false },
                           { description: 'La industria aeronáutica', question: questions[24], is_correct: false },
                           { description: 'La industria electrónica', question: questions[24], is_correct: false },

                           { description: 'Thomas Edison', question: questions[25], is_correct: false },
                           { description: 'James Watt', question: questions[25], is_correct: true },
                           { description: 'Alexander Graham Bell', question: questions[25], is_correct: false },
                           { description: 'Nikola Tesla', question: questions[25], is_correct: false },

                           { description: 'El sistema feudal', question: questions[26], is_correct: false },
                           { description: 'El sistema de talleres artesanales', question: questions[26], is_correct: false },
                           { description: 'El sistema fabril', question: questions[26], is_correct: true },
                           { description: 'El sistema de trueque', question: questions[26], is_correct: false },

                           { description: 'Una ley que prohibía el trabajo infantil', question: questions[27], is_correct: false },
                           { description: 'Una ley que permitía la privatización de tierras comunales', question: questions[27], is_correct: true },
                           { description: 'Una ley que regulaba los horarios de trabajo', question: questions[27], is_correct: false },
                           { description: 'Una ley que fomentaba la educación pública', question: questions[27], is_correct: false },

                           { description: 'El petróleo', question: questions[28], is_correct: false },
                           { description: 'El carbón', question: questions[28], is_correct: true },
                           { description: 'El gas natural', question: questions[28], is_correct: false },
                           { description: 'La madera', question: questions[28], is_correct: false },

                           { description: 'El avión', question: questions[29], is_correct: false },
                           { description: 'El automóvil', question: questions[29], is_correct: false },
                           { description: 'El tren', question: questions[29], is_correct: true },
                           { description: 'El barco de vapor', question: questions[29], is_correct: false }
                         ])