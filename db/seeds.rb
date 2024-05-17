# db/seeds.rb

questions = Question.create!([
                               { description: '¿Cuál de los siguientes animales es conocido por hibernar durante el invierno?' },
                               { description: '¿Cuál de las siguientes plantas es carnívora?' },
                               { description: '¿Cuál de los siguientes animales es un marsupial?' },
                               { description: '¿Cuál de los siguientes árboles es conocido por mantenerse verde durante todo el año?' },
                               { description: '¿Cuál de los siguientes animales es el mamífero más grande del mundo?' },
                               { description: '¿Cuál de las siguientes aves no puede volar?' },
                               { description: '¿Qué animal es famoso por su capacidad de cambiar de color para camuflarse con su entorno?' },
                               { description: '¿Cuál de los siguientes reptiles es venenoso?' },
                               { description: '¿Cuál de las siguientes plantas es una flor típica de la Navidad?' },
                               { description: '¿Cuál de los siguientes animales es conocido por tener una trompa larga y flexible?' },
                               { description: '¿Qué animal es popularmente conocido como el "rey de la selva"?' },
                               { description: '¿Cuál de las siguientes aves es capaz de migrar miles de kilómetros cada año?' },
                               { description: '¿Cuál de las siguientes plantas produce café?' },
                               { description: '¿Qué animal es conocido por su capacidad de regenerar partes de su cuerpo?' },
                               { description: '¿Cuál de los siguientes árboles produce frutos que son conocidos como "piñas"?' },
                               { description: '¿Cuál de las siguientes aves es el símbolo nacional de Estados Unidos?' },
                               { description: '¿Qué animal es conocido por su caparazón duro y su capacidad de retractar su cabeza dentro de él?' },
                               { description: '¿Cuál de las siguientes flores es típica de la celebración del Día de los Muertos en México?' },
                               { description: '¿Qué animal es famoso por su velocidad y su capacidad de saltar grandes distancias?' },
                               { description: '¿Cuál de las siguientes plantas es conocida por ser una fuente importante de alimento para los osos?' },
                               { description: '¿Quién fue el primer presidente constitucional de Argentina?' },
                               { description: '¿En qué año se produjo la Revolución de Mayo?' },
                               { description: '¿Cuál fue el período conocido como la Década Infame en Argentina?' },
                               { description: '¿Quién fue el líder del Ejército de los Andes durante la Campaña Libertadora de Chile y Perú?' },
                               { description: '¿Cuál fue la causa principal de la Guerra de las Malvinas en 1982?' },
                               { description: '¿Quién fue el presidente argentino durante la crisis económica de 2001?' },
                               { description: '¿Cuál de los siguientes fue un movimiento guerrillero activo durante la década de 1970 en Argentina?' },
                               { description: '¿Qué presidente argentino fue derrocado en el golpe de Estado de 1976, dando inicio a la última dictadura militar?' },
                               { description: '¿Cuál fue el nombre del movimiento liderado por Juan Domingo Perón que emergió en la política argentina durante la década de 1940?' },
                               { description: '¿Qué evento histórico llevó a la independencia de Argentina de España?' },
                               { description: '¿En qué deporte se utiliza una raqueta para golpear una pelota sobre una red?' },
                               { description: '¿Cuál de las siguientes ciudades es famosa por ser la sede de los Juegos Olímpicos de 2016?' },
                               { description: '¿Qué deporte se juega en una cancha con césped y dos equipos de once jugadores cada uno?' },
                               { description: '¿Cuál de los siguientes destinos turísticos es conocido por su Gran Cañón?' },
                               { description: '¿Qué deporte involucra lanzar una bola pesada lo más lejos posible en un área de lanzamiento?' },
                               { description: '¿Cuál de los siguientes países es famoso por sus templos antiguos y ruinas, incluido Angkor Wat?' },
                               { description: '¿En qué deporte los jugadores compiten en una pista de hielo utilizando zapatos con cuchillas para deslizarse?' },
                               { description: '¿Qué ciudad es conocida como "la ciudad eterna" por su rica historia y arquitectura antigua?' },
                               { description: '¿Cuál de los siguientes deportes es jugado en un campo con nueve hoyos o dieciocho hoyos?' },
                               { description: '¿Qué actividad turística es popular en el Parque Nacional de Yellowstone debido a sus géiseres y aguas termales?' },
                               { description: '¿En qué deporte los jugadores compiten para ver quién puede correr más rápido en una distancia específica?' },
                               { description: '¿Qué ciudad es famosa por sus canales, góndolas y arquitectura renacentista?' },
                               { description: '¿En qué deporte los jugadores intentan anotar puntos arrojando una pelota a través de un aro elevado?' },
                               { description: '¿Cuál de las siguientes atracciones turísticas se encuentra en la ciudad de Petra, en Jordania?' },
                               { description: '¿Qué deporte implica nadar, montar en bicicleta y correr en secuencia en una competencia?' },
                               { description: '¿Qué país es conocido por sus famosas pirámides, incluida la Gran Pirámide de Giza?' },
                               { description: '¿En qué deporte los jugadores golpean una pelota con un palo y tratan de hacerla entrar en un hoyo en el menor número de golpes?' },
                               { description: '¿Qué ciudad europea es famosa por su Torre Inclinada y su catedral?' },
                               { description: '¿Cuál de los siguientes deportes involucra lanzar un disco a una distancia máxima?' },
                               { description: '¿Qué país es famoso por su Gran Muralla, una antigua fortificación de miles de kilómetros de largo?' }
                             ])

answers = Answer.create!([
                 { description: 'Elefante', question: questions[0], is_correct: false },
                 { description: 'Ardilla', question: questions[0], is_correct: true },
                 { description: 'Cocodrilo', question: questions[0], is_correct: false },
                 { description: 'Jirafa', question: questions[0], is_correct: false },

                 { description: 'Rosa', question: questions[1], is_correct: false },
                 { description: 'Girasol', question: questions[1], is_correct: false },
                 { description: 'Venus atrapamoscas', question: questions[1], is_correct: true },
                 { description: 'Orquídea', question: questions[1], is_correct: false },

                 { description: 'Koala', question: questions[2], is_correct: true },
                 { description: 'Tigre', question: questions[2], is_correct: false },
                 { description: 'Elefante', question: questions[2], is_correct: false },
                 { description: 'León', question: questions[2], is_correct: false },

                 { description: 'Roble', question: questions[3], is_correct: false },
                 { description: 'Abedul', question: questions[3], is_correct: false },
                 { description: 'Pino', question: questions[3], is_correct: true },
                 { description: 'Arce', question: questions[3], is_correct: false },

                 { description: 'Elefante africano', question: questions[4], is_correct: false },
                 { description: 'Ballena azul', question: questions[4], is_correct: true },
                 { description: 'Oso polar', question: questions[4], is_correct: false },
                 { description: 'Jirafa', question: questions[4], is_correct: false },

                 { description: 'Águila', question: questions[5], is_correct: false },
                 { description: 'Pingüino', question: questions[5], is_correct: true },
                 { description: 'Lechuza', question: questions[5], is_correct: false },
                 { description: 'Colibrí', question: questions[5], is_correct: false },

                 { description: 'Camaleón', question: questions[6], is_correct: true },
                 { description: 'Tigre', question: questions[6], is_correct: false },
                 { description: 'Rinoceronte', question: questions[6], is_correct: false },
                 { description: 'Cebra', question: questions[6], is_correct: false },

                 { description: 'Tortuga', question: questions[7], is_correct: false },
                 { description: 'Serpiente de cascabel', question: questions[7], is_correct: true },
                 { description: 'Lagarto', question: questions[7], is_correct: false },
                 { description: 'Cocodrilo', question: questions[7], is_correct: false },

                 { description: 'Tulipán', question: questions[8], is_correct: false },
                 { description: 'Flor de loto', question: questions[8], is_correct: false },
                 { description: 'Pascua', question: questions[8], is_correct: true },
                 { description: 'Margarita', question: questions[8], is_correct: false },

                 { description: 'León', question: questions[9], is_correct: false },
                 { description: 'Elefante', question: questions[9], is_correct: true },
                 { description: 'Gorila', question: questions[9], is_correct: false },
                 { description: 'Oso pardo', question: questions[9], is_correct: false },

                 { description: 'León', question: questions[10], is_correct: true },
                 { description: 'Tigre', question: questions[10], is_correct: false },
                 { description: 'Gorila', question: questions[10], is_correct: false },
                 { description: 'Elefante', question: questions[10], is_correct: false },

                 { description: 'Golondrina', question: questions[11], is_correct: true },
                 { description: 'Búho', question: questions[11], is_correct: false },
                 { description: 'Cigüeña', question: questions[11], is_correct: false },
                 { description: 'Águila', question: questions[11], is_correct: false },

                 { description: 'Cacao', question: questions[12], is_correct: false },
                 { description: 'Maíz', question: questions[12], is_correct: false },
                 { description: 'Café', question: questions[12], is_correct: true },
                 { description: 'Trigo', question: questions[12], is_correct: false },

                 { description: 'Gato', question: questions[13], is_correct: false },
                 { description: 'Perro', question: questions[13], is_correct: false },
                 { description: 'Estrella de mar', question: questions[13], is_correct: true },
                 { description: 'Elefante', question: questions[13], is_correct: false },

                 { description: 'Roble', question: questions[14], is_correct: false },
                 { description: 'Abedul', question: questions[14], is_correct: false },
                 { description: 'Pino', question: questions[14], is_correct: true },
                 { description: 'Arce', question: questions[14], is_correct: false },

                 { description: 'Águila calva', question: questions[15], is_correct: true },
                 { description: 'Cisne', question: questions[15], is_correct: false },
                 { description: 'Pavo real', question: questions[15], is_correct: false },
                 { description: 'Búho', question: questions[15], is_correct: false },

                 { description: 'Cocodrilo', question: questions[16], is_correct: false },
                 { description: 'Tortuga', question: questions[16], is_correct: true },
                 { description: 'Lagarto', question: questions[16], is_correct: false },
                 { description: 'Serpiente', question: questions[16], is_correct: false },

                 { description: 'Rosa', question: questions[17], is_correct: false },
                 { description: 'Margarita', question: questions[17], is_correct: false },
                 { description: 'Cempasúchil', question: questions[17], is_correct: true },
                 { description: 'Orquídea', question: questions[17], is_correct: false },

                 { description: 'Tortuga', question: questions[18], is_correct: false },
                 { description: 'Liebre', question: questions[18], is_correct: true },
                 { description: 'Cocodrilo', question: questions[18], is_correct: false },
                 { description: 'Rana', question: questions[18], is_correct: false },

                 { description: 'Trigo', question: questions[19], is_correct: false },
                 { description: 'Maíz', question: questions[19], is_correct: false },
                 { description: 'Caña de azúcar', question: questions[19], is_correct: false },
                 { description: 'Bayas de sauco', question: questions[19], is_correct: true },

                 { description: 'Juan Domingo Perón', question: questions[20], is_correct: false },
                 { description: 'Bartolomé Mitre', question: questions[20], is_correct: true },
                 { description: 'Justo José de Urquiza', question: questions[20], is_correct: false },
                 { description: 'Bernardino Rivadavia', question: questions[20], is_correct: false },

                 { description: '1806', question: questions[21], is_correct: false },
                 { description: '1810', question: questions[21], is_correct: true },
                 { description: '1820', question: questions[21], is_correct: false },
                 { description: '1816', question: questions[21], is_correct: false },

                 { description: '1930-1940', question: questions[22], is_correct: true },
                 { description: '1880-1890', question: questions[22], is_correct: false },
                 { description: '1950-1960', question: questions[22], is_correct: false },
                 { description: '1810-1820', question: questions[22], is_correct: false },

                 { description: 'José de San Martín', question: questions[23], is_correct: true },
                 { description: 'Manuel Belgrano', question: questions[23], is_correct: false },
                 { description: 'Juan Lavalle', question: questions[23], is_correct: false },
                 { description: 'Domingo Faustino Sarmiento', question: questions[23], is_correct: false },

                 { description: 'Disputa por recursos naturales', question: questions[24], is_correct: false },
                 { description: 'Conflicto étnico', question: questions[24], is_correct: false },
                 { description: 'Disputa religiosa', question: questions[24], is_correct: false },
                 { description: 'Control de rutas comerciales', question: questions[24], is_correct: false },

                 { description: 'Fernando de la Rúa', question: questions[25], is_correct: true },
                 { description: 'Carlos Menem', question: questions[25], is_correct: false },
                 { description: 'Néstor Kirchner', question: questions[25], is_correct: false },
                 { description: 'Mauricio Macri', question: questions[25], is_correct: false },

                 { description: 'Montoneros', question: questions[26], is_correct: true },
                 { description: 'La Triple A', question: questions[26], is_correct: false },
                 { description: 'Ejército Revolucionario del Pueblo (ERP)', question: questions[26], is_correct: true },
                 { description: 'Liga Patriótica Argentina', question: questions[26], is_correct: false },

                 { description: 'Isabel Perón', question: questions[27], is_correct: true },
                 { description: 'Arturo Illia', question: questions[27], is_correct: false },
                 { description: 'Raúl Alfonsín', question: questions[27], is_correct: false },
                 { description: 'Juan Domingo Perón', question: questions[27], is_correct: false },

                 { description: 'Justicialismo', question: questions[28], is_correct: true },
                 { description: 'Radicalismo', question: questions[28], is_correct: false },
                 { description: 'Conservadurismo', question: questions[28], is_correct: false },
                 { description: 'Liberalismo', question: questions[28], is_correct: false },

                 { description: 'La Revolución de Mayo', question: questions[29], is_correct: true },
                 { description: 'La Guerra del Paraguay', question: questions[29], is_correct: false },
                 { description: 'La Batalla de Caseros', question: questions[29], is_correct: false },
                 { description: 'La Conquista del Desierto', question: questions[29], is_correct: false },

                 { description: 'Fútbol', question: questions[30], is_correct: false },
                 { description: 'Tenis', question: questions[30], is_correct: true },
                 { description: 'Baloncesto', question: questions[30], is_correct: false },
                 { description: 'Golf', question: questions[30], is_correct: false },

                 { description: 'Madrid', question: questions[31], is_correct: false },
                 { description: 'París', question: questions[31], is_correct: false },
                 { description: 'Río de Janeiro', question: questions[31], is_correct: true },
                 { description: 'Tokio', question: questions[31], is_correct: false },

                 { description: 'Baloncesto', question: questions[32], is_correct: false },
                 { description: 'Fútbol', question: questions[32], is_correct: true },
                 { description: 'Voleibol', question: questions[32], is_correct: false },
                 { description: 'Golf', question: questions[32], is_correct: false },

                 { description: 'Yellowstone (EE. UU.)', question: questions[33], is_correct: false },
                 { description: 'Machu Picchu (Perú)', question: questions[33], is_correct: false },
                 { description: 'Gran Barrera de Coral (Australia)', question: questions[33], is_correct: false },
                 { description: 'Parque Nacional del Gran Cañón (EE. UU.)', question: questions[33], is_correct: true },

                 { description: 'Atletismo', question: questions[34], is_correct: false },
                 { description: 'Golf', question: questions[34], is_correct: false },
                 { description: 'Lanzamiento de peso', question: questions[34], is_correct: true },
                 { description: 'Béisbol', question: questions[34], is_correct: false },

                 { description: 'Tailandia', question: questions[35], is_correct: false },
                 { description: 'India', question: questions[35], is_correct: false },
                 { description: 'Camboya', question: questions[35], is_correct: true },
                 { description: 'China', question: questions[35], is_correct: false },

                 { description: 'Hockey sobre hielo', question: questions[36], is_correct: true },
                 { description: 'Patinaje artístico', question: questions[36], is_correct: true },
                 { description: 'Esquí alpino', question: questions[36], is_correct: false },
                 { description: 'Snowboard', question: questions[36], is_correct: false },

                 { description: 'París', question: questions[37], is_correct: false },
                 { description: 'Roma', question: questions[37], is_correct: true },
                 { description: 'Atenas', question: questions[37], is_correct: false },
                 { description: 'Estambul', question: questions[37], is_correct: false },

                 { description: 'Fútbol americano', question: questions[38], is_correct: false },
                 { description: 'Golf', question: questions[38], is_correct: true },
                 { description: 'Béisbol', question: questions[38], is_correct: false },
                 { description: 'Cricket', question: questions[38], is_correct: false },

                 { description: 'Buceo', question: questions[39], is_correct: false },
                 { description: 'Espeleología', question: questions[39], is_correct: false },
                 { description: 'Senderismo', question: questions[39], is_correct: true },
                 { description: 'Observación de la vida salvaje', question: questions[39], is_correct: true },

                 { description: 'Atletismo', question: questions[40], is_correct: true },
                 { description: 'Natación', question: questions[40], is_correct: true },
                 { description: 'Ciclismo', question: questions[40], is_correct: true },
                 { description: 'Esgrima', question: questions[40], is_correct: false },

                 { description: 'París', question: questions[41], is_correct: false },
                 { description: 'Venecia', question: questions[41], is_correct: true },
                 { description: 'Ámsterdam', question: questions[41], is_correct: false },
                 { description: 'Praga', question: questions[41], is_correct: false },

                 { description: 'Fútbol', question: questions[42], is_correct: false },
                 { description: 'Baloncesto', question: questions[42], is_correct: true },
                 { description: 'Voleibol', question: questions[42], is_correct: false },
                 { description: 'Rugby', question: questions[42], is_correct: false },

                 { description: 'La Gran Muralla China', question: questions[43], is_correct: false },
                 { description: 'La Torre Eiffel', question: questions[43], is_correct: false },
                 { description: 'El Coliseo Romano', question: questions[43], is_correct: false },
                 { description: 'El Tesoro de Petra', question: questions[43], is_correct: true },

                 { description: 'Tenis', question: questions[44], is_correct: false },
                 { description: 'Triatlón', question: questions[44], is_correct: true },
                 { description: 'Boxeo', question: questions[44], is_correct: false },
                 { description: 'Fórmula 1', question: questions[44], is_correct: false },

                 { description: 'México', question: questions[45], is_correct: false },
                 { description: 'Egipto', question: questions[45], is_correct: true },
                 { description: 'Italia', question: questions[45], is_correct: false },
                 { description: 'Grecia', question: questions[45], is_correct: false },

                 { description: 'Fútbol', question: questions[46], is_correct: false },
                 { description: 'Rugby', question: questions[46], is_correct: false },
                 { description: 'Golf', question: questions[46], is_correct: true },
                 { description: 'Cricket', question: questions[46], is_correct: false },

                 { description: 'Londres', question: questions[47], is_correct: false },
                 { description: 'Berlín', question: questions[47], is_correct: false },
                 { description: 'Pisa', question: questions[47], is_correct: true },
                 { description: 'Barcelona', question: questions[47], is_correct: false },

                 { description: 'Golf', question: questions[48], is_correct: false },
                 { description: 'Lanzamiento de disco', question: questions[48], is_correct: true },
                 { description: 'Béisbol', question: questions[48], is_correct: false },
                 { description: 'Esgrima', question: questions[48], is_correct: false },

                 { description: 'China', question: questions[49], is_correct: true },
                 { description: 'India', question: questions[49], is_correct: false },
                 { description: 'Rusia', question: questions[49], is_correct: false },
                 { description: 'Brasil', question: questions[49], is_correct: false },

               ])









