enum Lang { es, en }

class L10n {
  static const Map<String, Map<Lang, String>> _s = {
    'title': {Lang.es: "El Campo de Atenea", Lang.en: "Atenea's Field"},
    'start': {Lang.es: 'COMENZAR', Lang.en: 'START'},
    'level': {Lang.es: 'Nivel', Lang.en: 'Level'},
    'ojo': {Lang.es: 'Ojo de Argos', Lang.en: 'Eye of Argos'},
    'correction': {Lang.es: 'Corrección', Lang.en: 'Correction'},
    'miopia_msg': {
      Lang.es: '¡Las cajas han cambiado de lugar!',
      Lang.en: 'The boxes have moved!'
    },
    'ojo_used': {
      Lang.es: 'Espero que hayas tomado nota de las trampas.',
      Lang.en: 'I hope you took note of the traps.'
    },
    'correction_applied': {
      Lang.es: 'Atenea ha corregido los números.',
      Lang.en: 'Atenea has corrected the numbers.'
    },
    'correction_waste_1': {
      Lang.es: 'Los números estaban bien. Tú no. Ítem perdido.',
      Lang.en: 'The numbers were fine. You weren\'t. Item lost.'
    },
    'correction_waste_2': {
      Lang.es: 'Usaste tu Corrección Ateniense para nada.',
      Lang.en: 'You used your Athenian Correction for nothing.'
    },
    'correction_waste_3': {
      Lang.es: 'No había nada que corregir. Has desperdiciado un ítem valioso.',
      Lang.en: 'Nothing to fix. You wasted a valuable item.'
    },
    'correction_waste_4': {
      Lang.es: '¡Sí serás...! Has desperdiciado un ítem valioso.',
      Lang.en: 'Oh come on! You wasted a valuable item.'
    },
    'pandora_msg': {
      Lang.es:
          'Has liberado todos los males... menos la esperanza. Esa la perdiste al hacer clic.',
      Lang.en:
          'You released all the evils... except hope. You lost that when you clicked.'
    },
    'pandora_msg_1': {
      Lang.es:
          'Abriste la caja, salieron todos los males... y tú decidiste quedarte a recibirlos.',
      Lang.en:
          'You opened the box, every evil came out... and you chose to stick around for them.'
    },
    'pandora_msg_2': {
      Lang.es:
          'Pandora te lo advirtió. Bueno, no a ti directamente. Pero vamos, era obvio.',
      Lang.en:
          'Pandora warned you. Well, not you specifically. But come on, it was obvious.'
    },
    'pandora_msg_3': {
      Lang.es:
          'Liberaste el caos, la enfermedad, la vejez... y tu dignidad. Esa también.',
      Lang.en:
          'You unleashed chaos, disease, old age... and your dignity. That one too.'
    },
    'pandora_msg_4': {
      Lang.es:
          'La esperanza quedó dentro de la caja. Tú quedaste fuera de la partida.',
      Lang.en:
          'Hope stayed inside the box. You stayed out of the game.'
    },
    'pandora_msg_5': {
      Lang.es:
          'Pandora abrió la caja por curiosidad. Tú la abriste por... ¿aburrimiento? Peor excusa.',
      Lang.en:
          'Pandora opened the box out of curiosity. You opened it out of... boredom? Worse excuse.'
    },
    'pandora_msg_6': {
      Lang.es: 'Zeus te veía. Zeus no está contento. Zeus tiene razón.',
      Lang.en: 'Zeus was watching. Zeus is not pleased. Zeus is right.'
    },
    'pandora_msg_7': {
      Lang.es:
          'Has desatado todos los males de la humanidad. Y lo peor: perdiste en un juego de los 90.',
      Lang.en:
          'You have unleashed every evil on humanity. And worse: you lost a \'90s game.'
    },
    'pandora_msg_8': {
      Lang.es:
          'Pandora al menos tuvo la excusa de ser un mito. Tú no tienes excusa.',
      Lang.en:
          'Pandora at least had the excuse of being a myth. You have none.'
    },
    'pandora_msg_9': {
      Lang.es:
          'Atenea te dio sabiduría... y tú la cambiaste por un clic impulsivo.',
      Lang.en:
          'Atenea gave you wisdom... and you traded it for an impulsive click.'
    },
    'pandora_msg_10': {
      Lang.es:
          'La diosa de la estrategia acaba de anotarte en su lista de decepciones.',
      Lang.en:
          'The goddess of strategy just added you to her list of disappointments.'
    },
    'pandora_msg_11': {
      Lang.es:
          'Atenea: "Podrías haber marcado esa casilla con bandera". Tú: "No me dio la gana". También tú: pierdes.',
      Lang.en:
          'Atenea: "You could have flagged that cell." You: "Didn\'t feel like it." Also you: lose.'
    },
    'pandora_msg_12': {
      Lang.es:
          'Atenea te observaba. Y tomó notas. Las notas dicen: "No invitarlo al próximo Olimpo".',
      Lang.en:
          'Atenea was watching. And took notes. The notes say: "Do not invite them to the next Olympus."'
    },
    'pandora_msg_13': {
      Lang.es: 'Boom. Y no del de chocolate.',
      Lang.en: 'Boom. And not the chocolate kind.'
    },
    'pandora_msg_14': {
      Lang.es: 'Clic. Muerte. Fin de la historia. Muy dramático todo.',
      Lang.en: 'Click. Death. End of story. Very dramatic.'
    },
    'pandora_msg_15': {
      Lang.es: 'Has perdido. La mitología te juzga y te encuentra... mal.',
      Lang.en: 'You lost. Mythology judges you and finds you... lacking.'
    },
    'pandora_msg_16': {
      Lang.es:
          'En la Grecia antigua te habrían exiliado. Aquí sólo pierdes. Suerte.',
      Lang.en:
          'In ancient Greece they would have exiled you. Here you just lose. Lucky you.'
    },
    'pandora_msg_17': {
      Lang.es: 'Pandora se ríe de ti. Atenea también. Hades te espera.',
      Lang.en: 'Pandora laughs at you. So does Atenea. Hades is waiting.'
    },
    'pandora_msg_18': {
      Lang.es:
          'Hades ya tiene tu asiento reservado. Por si vuelves a perder.',
      Lang.en:
          'Hades already has your seat reserved. In case you lose again.'
    },
    'pandora_msg_19': {
      Lang.es:
          'Zeus te lanza un rayo. No físicamente. Pero emocionalmente sí.',
      Lang.en:
          'Zeus hurls a bolt at you. Not physically. But emotionally, yes.'
    },
    'pandora_msg_20': {
      Lang.es: 'Tántalo tenía hambre. Tú tenías un clic fácil. Los dos fracasaron.',
      Lang.en: 'Tantalus was hungry. You had an easy click. Both failed.'
    },
    'pandora_msg_21': {
      Lang.es:
          'Sísifo empuja una piedra. Tú haces clic en minas. Ninguno aprende.',
      Lang.en:
          'Sisyphus pushes a rock. You click on mines. Neither one learns.'
    },
    'pandora_msg_22': {
      Lang.es:
          'Orfeo miró atrás. Tú miraste mal la cuadrícula. Finales tristes clásicos.',
      Lang.en:
          'Orpheus looked back. You misread the grid. Classic sad endings.'
    },
    'pandora_msg_23': {
      Lang.es: 'No fue mala suerte. Fue mala decisión. Hay diferencia.',
      Lang.en: 'It wasn\'t bad luck. It was a bad decision. There\'s a difference.'
    },
    'pandora_msg_24': {
      Lang.es:
          'El juego no te engañó. Tú te engañaste solo. Pero gracias por echarle la culpa al código.',
      Lang.en:
          'The game didn\'t fool you. You fooled yourself. But thanks for blaming the code.'
    },
    'pandora_msg_25': {
      Lang.es:
          'Pandora guardó la esperanza. Tú guardaste el clic fatal. Cosas de la vida.',
      Lang.en:
          'Pandora kept the hope. You kept the fatal click. That\'s life.'
    },
    'pandora_msg_26': {
      Lang.es:
          'Estadísticamente, tenías que perder en algún momento. Ese momento fue justo ahora.',
      Lang.en:
          'Statistically, you had to lose at some point. That point was right now.'
    },
    'win_msg': {
      Lang.es: '¡Nivel superado! Atenea sonríe.',
      Lang.en: 'Level complete! Atenea smiles.'
    },
    'item_ojo': {
      Lang.es: '¡Un Ojo de Argos para ti!',
      Lang.en: 'An Eye of Argos for you!'
    },
    'item_correction': {
      Lang.es: '¡Una Corrección Ateniense apareció!',
      Lang.en: 'An Athenian Correction appeared!'
    },
    'hades': {Lang.es: 'Casco de Hades', Lang.en: 'Helm of Hades'},
    'item_hades': {
      Lang.es: '¡Un Casco de Hades apareció!',
      Lang.en: 'A Helm of Hades appeared!'
    },
    'hades_armed': {
      Lang.es:
          'El Casco de Hades te protegerá en tu siguiente clic... pero pagarás el precio.',
      Lang.en:
          'The Helm of Hades will shield your next click... but you will pay the price.'
    },
    'next': {Lang.es: 'Siguiente', Lang.en: 'Next'},
    'finish': {Lang.es: 'Terminar', Lang.en: 'Finish'},
    'score': {Lang.es: 'Puntaje', Lang.en: 'Score'},
    'record': {Lang.es: 'Récord', Lang.en: 'Record'},
    'new_record': {Lang.es: '¡Nuevo récord!', Lang.en: 'New record!'},
    'enter_initials': {
      Lang.es: 'Iniciales',
      Lang.en: 'Initials'
    },
    'save_record': {Lang.es: 'Guardar', Lang.en: 'Save'},
    'level_score': {Lang.es: 'Este nivel', Lang.en: 'This level'},
    'total_score': {Lang.es: 'Total', Lang.en: 'Total'},
    'retry': {Lang.es: 'Reintentar', Lang.en: 'Retry'},
    'close': {Lang.es: 'Cerrar', Lang.en: 'Close'},
    'use': {Lang.es: 'Usar', Lang.en: 'Use'},
    'ojo_desc': {
      Lang.es: 'Revela todas las casillas seguras durante 2 segundos.',
      Lang.en: 'Reveals all safe cells for 2 seconds.'
    },
    'correction_desc': {
      Lang.es:
          'Atenea corrige los números del tablero cuando están desactualizados.',
      Lang.en:
          'Atenea corrects the board numbers when they are outdated.'
    },
    'hades_desc': {
      Lang.es:
          'Tu siguiente clic siempre será seguro, pero añadirá 2 cajas de Pandora y los números se desactualizarán.',
      Lang.en:
          'Your next click is guaranteed safe, but adds 2 Pandora boxes and the numbers will go stale.'
    },
    'difficulty': {Lang.es: 'Dificultad', Lang.en: 'Difficulty'},
    'easy': {Lang.es: 'Fácil', Lang.en: 'Easy'},
    'medium': {Lang.es: 'Normal', Lang.en: 'Medium'},
    'hard': {Lang.es: 'Difícil', Lang.en: 'Hard'},
    'audio': {Lang.es: 'Audio', Lang.en: 'Audio'},
    'music': {Lang.es: 'Música', Lang.en: 'Music'},
    'sfx': {Lang.es: 'Efectos', Lang.en: 'SFX'},
    'confirm_restart': {
      Lang.es: '¿Reiniciar? Perderás el progreso y los ítems.',
      Lang.en: 'Restart? You will lose progress and items.'
    },
    'cancel': {Lang.es: 'Cancelar', Lang.en: 'Cancel'},
    'restart': {Lang.es: 'Reiniciar', Lang.en: 'Restart'},
    'save_image': {Lang.es: 'Guardar imagen', Lang.en: 'Save image'},
    'saved_ok': {
      Lang.es: 'Imagen guardada en la galería.',
      Lang.en: 'Image saved to gallery.'
    },
    'saved_fail': {
      Lang.es: 'No se pudo guardar la imagen.',
      Lang.en: 'Could not save the image.'
    },
    'extra_pandoras': {
      Lang.es: 'Cajas de Pandora extra',
      Lang.en: 'Extra Pandora boxes'
    },
    'add': {Lang.es: 'Añadir', Lang.en: 'Add'},
  };

  static String t(String key, Lang lang) =>
      _s[key]?[lang] ?? _s[key]?[Lang.es] ?? key;
}
