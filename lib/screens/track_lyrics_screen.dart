import 'package:flutter/material.dart';

class TrackLyricsScreen extends StatelessWidget {
  final String trackId;
  final String trackTitle;
  final String artistName;
  final String featuring;

  const TrackLyricsScreen({
    Key? key,
    required this.trackId,
    required this.trackTitle,
    required this.artistName,
    required this.featuring,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simuler les paroles pour la démo
    final lyrics = '''
[Chorus: Beyoncé & Eminem]
I walk on water
But I ain't no Jesus
I walk on water
But only when it freezes

[Verse 1: Eminem]
Why are expectations so high?
Is it the bar I set?
My arms, I stretch, but I can't reach
A far cry from it, or it's in my grasp, but as
Soon as I grab, squeeze
I lose my grip like the flying trapeze
Into the dark, I plummet, now the sky's
Blackening, like I'm in hawk, I plunge
When will I ever learn to fly?
Like a "sick bird", bitch, I flew to the dirt and suicide
This is my recital, I've just
Awoken, I'm walking in my sleep
I'm about to peak, criticism, wait for the reviews wait
That's not what I meant when I said it
My pen, I said it
Shit, it, here we go again

[Chorus: Beyoncé & Eminem]
I walk on water
But I ain't no Jesus
I walk on water
But only when it freezes

[Bridge: Beyoncé]
'Cause I'm only human, just like you
Making my mistakes, oh if you only knew
I don't think you should believe in me the way that you do
'Cause I'm terrified to let you down, oh

[Verse 2: Eminem]
It's true, I'm a rubix, a beautiful mess
At times juvenile, yes, I goof and I jest
A flawed human, I guess
But I'm doin' my best to not ruin your expec-
tations and meet 'em, but first, the "Speedom" verse
Now Big Sean, he's going too fast
Is he gonna shout or curse out his mom?
There was a time I had the world by the balls, eating out
My palm, every album, song I was spazzin' the fuck out on
And now I'm getting clowned and frowned on
But the only one who's looking down on
Me that matters now's Deshaun
Am I lucky to be around this long?
Begs the question though
Especially after the methadone
As yesterday fades and the Dresden home
Is burnt to the ground and all that's left of my house is lawn
The crowds are gone
And it's time to wash out the blonde
Sales decline, the curtains drawn
They're closin' the set, I'm still pokin' my head from out the window
I'm not going to bow out until I choke from it
Whole world, career in tailspin, like a flight when
It's a full-time job to manage this light skin
But when I do pull through and spring ahead of the pack, motherfuckers
Are still ichin' to hate, "I just can't scratch up that itch"
Something something sprin'ing I forget
'Cause by the time I remember to say something, it's fucking late, it's spring
Fuck, I just didn't say nothing!''';

    // Convertir le texte complet en blocs pour mettre en évidence les parties
    // comme le Chorus, Verse, etc.
    final List<Map<String, dynamic>> formattedLyrics = [];
    
    // Diviser les paroles en lignes
    final lines = lyrics.split('\n');
    String currentSection = '';
    String currentSectionText = '';
    
    for (final line in lines) {
      if (line.contains('[') && line.contains(']')) {
        // Si on a déjà accumulé du texte, on l'ajoute
        if (currentSectionText.isNotEmpty) {
          formattedLyrics.add({
            'header': currentSection,
            'text': currentSectionText.trim(),
          });
        }
        // On démarre une nouvelle section
        currentSection = line;
        currentSectionText = '';
      } else {
        currentSectionText += line + '\n';
      }
    }
    
    // Ajouter la dernière section
    if (currentSectionText.isNotEmpty) {
      formattedLyrics.add({
        'header': currentSection,
        'text': currentSectionText.trim(),
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Paroles',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.black),
            onPressed: () {
              // Fonction pour ajouter aux favoris
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // En-tête avec le titre et l'artiste
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[100],
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trackTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$artistName${featuring.isNotEmpty ? ' & $featuring' : ''}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          // Paroles défilantes
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: formattedLyrics.length,
              itemBuilder: (context, index) {
                final section = formattedLyrics[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (section['header'].isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          section['header'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    Text(
                      section['text'],
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}