-- Group 111
-- Team members: Carter McQuigg, Brandon Nguyen
-- Project: MelodyHarbor


-- Setup to minimize import errors
SET FOREIGN_KEY_CHECKS = 0;
SET AUTOCOMMIT = 0;


----------------------------------
-- Create Tables
----------------------------------

CREATE OR REPLACE Table RecordLabels (
	labelID int NOT NULL AUTO_INCREMENT,
	name varchar(50) NOT NULL,
	location varchar(30),
	PRIMARY KEY (labelID)
);

CREATE OR REPLACE Table Artists (
	artistID int NOT NULL AUTO_INCREMENT,
	name varchar(50) NOT NULL,
	listenerCt int,
	cityOfOrigin varchar(30),
	labelID int DEFAULT NULL,
	PRIMARY KEY (artistID),
	FOREIGN KEY (labelID) REFERENCES RecordLabels(labelID)
	ON DELETE SET NULL
);

CREATE OR REPLACE Table Albums (
	albumID int NOT NULL AUTO_INCREMENT,
	title varchar(50) NOT NULL,
	genre varchar(20),
	artistID int,
	PRIMARY KEY (albumID),
	FOREIGN KEY (artistID) REFERENCES Artists(artistID)
	ON DELETE CASCADE
);

CREATE OR REPLACE Table Songs (
	songID int NOT NULL AUTO_INCREMENT,
	name varchar(50) NOT NULL,
	streamCt bigint,
	genre varchar(20),
	keySignature varchar(20),
	chordProgression varchar(30),
	lowRange int,
	highRange int,
	albumID int,
  	lyrics text,
	PRIMARY KEY (songID),
	FOREIGN KEY (albumID) REFERENCES Albums(albumID)
	ON DELETE SET NULL
);

CREATE OR REPLACE Table SongArtists (
	songArtistsID int NOT NULL AUTO_INCREMENT,
	songID int,
	artistID int,
	PRIMARY KEY (songArtistsID),
	FOREIGN KEY (artistID) REFERENCES Artists(artistID)
	ON DELETE CASCADE,
	FOREIGN KEY (songID) REFERENCES Songs(songID)
	ON DELETE CASCADE
);


----------------------------------
-- Insert Example Data
----------------------------------

INSERT INTO RecordLabels (name, location)
VALUES ('Dreamville','New York City, New York'),
('pgLang','Los Angeles, California'),
('88rising','Los Angeles, California'),
('Fiction Records','United Kingdom');

INSERT INTO Artists (name, listenerCt, cityOfOrigin, labelID)
VALUES ('JID',24990531,'Atlanta, Georgia',(SELECT labelID FROM RecordLabels WHERE name = 'Dreamville')),
('Kendrick Lamar',61211039,'Compton, California',(SELECT labelID FROM RecordLabels WHERE name = 'pgLang')),
('Baby Keem',20846955,'Carson, California',(SELECT labelID FROM RecordLabels WHERE name = 'pgLang')),
('J. Cole',43895498,'Fayetteville, North Carolina',(SELECT labelID FROM RecordLabels WHERE name = 'Dreamville')),
('Joji',19767425,'Higashinada-ku, Kobe, Japan',(SELECT labelID FROM RecordLabels WHERE name = '88rising')),
('Palace',1929362,'London, United Kingdom',(SELECT labelID FROM RecordLabels WHERE name = 'Fiction Records')),
('Magpie Jay',26991,'San Jose, Costa Rica',NULL);

INSERT INTO Albums (title, genre, artistID)
VALUES ('2014 Forest Hills Drive','Hip Hop',(SELECT artistID FROM Artists WHERE name = 'J. Cole')),
('The Melodic Blue','Hip Hop',(SELECT artistID FROM Artists WHERE name = 'Baby Keem')),
('To Pimp A Butterfly','Hip Hop',(SELECT artistID FROM Artists WHERE name = 'Kendrick Lamar')),
('DiCaprio 2','Hip Hop',(SELECT artistID FROM Artists WHERE name = 'JID')),
('So Long Forever','Alternative/Indie',(SELECT artistID FROM Artists WHERE name = 'Palace')),
('Monte Claro','Rock',(SELECT artistID FROM Artists WHERE name = 'Magpie Jay'));

INSERT INTO Songs (name, streamCt, genre, keySignature, chordProgression, lowRange, highRange, lyrics, albumID)
VALUES ('No Role Modelz',2180254470,'Hip Hop','F Minor','VI iv i III',56,63,CONCAT('First things first: rest in peace, Uncle Phil\n','For real\n','You the only father that I ever knew\n','I get my bitch pregnant, I''ma be a better you\n','Prophecies that I made way back in the Ville\n','Fulfilled\n','Listen, even back when we was broke, my team ill\n','Martin Luther King woulda been on Dreamville, talk to a nigga\n','One time for my L.A. sisters\n','One time for my L.A. ho\n','Lame niggas can''t tell the difference\n','One time for a nigga who know\n','Don''t save her, she don''t wanna be saved\n','Don''t save her, she don''t wanna be saved\n','Don''t save her, she don''t wanna be saved\n','Don''t save her, she don''t wanna be saved\n','No role models, and I''m here right now\n','No role models to speak of\n','Searchin'' through my memory, my memory, I couldn''t find one\n','Last night, I was gettin'' my feet rubbed by the baddest bitch\n','Not Trina, but I swear to God, this bitch''ll make you call your girl up\n','And tell her, "Hey, what''s good?\n','Sorry, I''m never comin'' home, I''ma stay for good"\n','Then hang the phone up and proceed to lay the wood\n','I came fast like 9-1-1 in white neighborhoods\n','Ain''t got no shame ''bout it\n','She think I''m spoiled and I''m rich ''cause I can have any bitch\n','I got defensive and said, ""Nah, I was the same without it""\n','But then I thought back, back to a better me\n','Before I was a B-list celebrity\n','''Fore I started callin'' bitches "bitches" so heavily\n','Back when you could get a platinum plaque without no melody, you wadn''t sweatin'' me\n','One time for my L.A. sisters\n','One time for my L.A. ho\n','Lame niggas can''t tell the difference\n','One time for a nigga who know\n','Don''t save her, she don''t wanna be saved\n','Don''t save her, she don''t wanna be saved\n','Don''t save her, she don''t wanna be saved\n','Don''t save her, she don''t wanna be saved\n','I want a real love, dark-skinned Aunt Viv love\n','That Jada and that Will love\n','That leave a toothbrush at your crib love\n','And you ain''t gotta wonder whether that''s your kid love\n','Nigga, I don''t want no bitch from reality shows\n','Out-of-touch-with-reality hoes\n','Out in Hollywood bringin'' back five or six hoes\n','Fuck ''em then we kick ''em to the do'', nigga, you know how it go\n','She deserved that, she a bird, it''s a bird trap\n','You think if I didn''t rap she would flirt back?\n','Takin'' off her skirt, let her wear my shirt, ''fore she leave\n','"I''ma need my shirt back" (Nigga, you know how it go)\n','One time for my L.A. sisters\n','One time for my L.A. ho\n','Lame niggas can''t tell the difference\n','One time for a nigga who know\n','Don''t save her, she don''t wanna be saved\n','Don''t save her, she don''t wanna be saved\n','Don''t save her, she don''t wanna be saved\n','Don''t save her, she don''t wanna be saved\n','There''s an old saying in Tennessee I know it''s in Texas, probably in Tennessee that says, fool me once... shame on... shame on you\n','Fool me can''t get fooled again\n','Fool me one time, shame on you (Ayy)\n','Fool me twice, can''t put the blame on you (Ayy)\n','Fool me three times, fuck the peace sign\n','Load the chopper, let it rain on you (Bop, bop, bop)\n','Fool me one time, shame on you (Ayy)\n','Fool me twice, can''t put the blame on you (Ayy)\n','Fool me three times, fuck the peace sign\n','Load the chopper, let it rain on you (Bop, bop, bop)\n','My only regret was too young for Lisa Bonet\n','My only regret was too young for Nia Long\n','Now all I''m left with is hoes from reality shows\n','Hand her a script, the bitch prolly couldn''t read along\n','My only regret was too young for Sade Adu\n','My only regret, could never take Aaliyah home\n','Now all I''m left with is hoes up in Greystone\n','With the stale face ''cause they know it''s they song\n','She shallow but the pussy deep (She shallow, She shallow)\n','She shallow but the pussy deep (She shallow), yeah, ayy (She shallow)\n','She shallow but the pussy deep (She shallow), haha (She shallow)\n','She shallow but the pussy deep (She shallow, She shallow)\n','Don''t save her, she don''t wanna be saved\n','Don''t save her, she don''t wanna be saved\n','Don''t save her, she don''t wanna be saved\n','Don''t save her, she don''t wanna be saved\n','Don''t save her, she don''t wanna be saved\n','Don''t save her, she don''t wanna be saved\n','Don''t save her, she don''t wanna be saved\n','Don''t save her, she don''t wanna be saved'),(SELECT albumID FROM Albums WHERE title = '2014 Forest Hills Drive')),
('Live Well',111265823,'Alternative/Indie','D Major','I I ii vi',54,69,CONCAT('Sundown\n','Ever so slow now\n','Remind me I''m a free man\n','Free-er than I''ve been\n','It''s something I''m feeling\n','I''m wonderfully breathing\n','Blessed in the rainfall\n','Cleansed like the downpour\n','And I know it''s fine to end our time\n','Be safe, be true, and I''ll think of you\n','Live well, you reap what you sow\n','The future is bright if we can ebb with the flow\n','You''re something, I''m nothing, we were everything\n','Anything to save me from the goodness she gave me\n','Moonrise\n','Over my headlights\n','And I''m on the right trail\n','I''ve taken my life there\n','And tied it upside down\n','You''re living for that sweet sound\n','You laugh like the warm sun\n','Cuts through me like the only one\n','And I know it''s fine to end our time\n','Be safe, be true, and I''ll think of you\n','Live well, you reap what you sow\n','The future is bright if we can ebb with the flow\n','You''re something, I''m nothing, we were everything\n','Anything to save me from the goodness she gave me\n','It''s nothing less, a mystery\n','How it came to this I see\n','And if it comes to this I know\n','We''ll have had more than most did so\n','In a dream that I have had\n','We departed, ended what we had started\n','And I pray it doesn''t come to that\n','If it does thanks for the love we had\n','Live well, you reap what you sow\n','The future is bright if we can ebb with the flow\n','You''re something, I''m nothing, we were everything\n','Anything to save me from the goodness she gave me\n','Live well, you reap what you sow\n','The future is bright if we can ebb with the flow\n','You''re something, I''m nothing, we were everything\n','Anything to save me from the goodness she gave me'),(SELECT albumID FROM Albums WHERE title = 'So Long Forever')),
('20',1522020,'Rock','A Minor','i VII',50,67,CONCAT('I''ve tried to tell you my good friends are assets.\n','I met them long ago in school through laughter.\n','They''ve got so many traits I love and so do I.\n','We''ve got some complex thoughts I place in simple rhyme.\n','When I was younger long ago when everything was clear so I knew no fear.\n','My mother told me I was way to small to handle an experience my mind would steer.\n','My thoughts were all so loose they covered every reason and personal truth; my crazy mind I owe it to myself and I just swear that this ain''t a threat.\n','And as the sun brightly shines, I love the fact I''m alive.\n','Thought I was greatly disguised, I only learned I was blind.\n','This small place I call home where everything is green and the water''s blue, there are places so high and tough but still I go places where I can hide from the versatility I want back.\n','I just want you to sit right back here with me.\n','And as the sun brightly shines, I love the fact I''m alive.\n','Thought I was greatly disguised, I only learned I was blind.\n','I thought all horror stories were behind me.\n','I told my mama how badly I was sorry.\n','Someday I''ll fix the mistakes and wrongs that are not the end of the story I''m telling you now.'),(SELECT albumID FROM Albums WHERE title = 'Monte Claro')),
('family ties',746638520,'Hip Hop',NULL,NULL,NULL,NULL,CONCAT('Jump in that (huh, huh), summon that bitch\n','Jump in that (huh, huh), jump in that fire, jump in that bitch\n','Hittin'' that fire, jump in that whip, thumbin'' that bitch\n','Cum in that bitch (ho), drummin'' that (huh, huh)\n','Drummin'' that bitch (yeah)\n','Chopper doin'' circles, it''s a Vert'', Vert''\n','Take him to the projects, he''s a nerd (Pop out)\n','I see niggas hittin'' corners in the motherfuckin'' ''burbs, huh (Pop out)\n','Done politickin'' with the competition, what''s the word? (Yeah)\n','Put that on my mama, nigga, ate in the process\n','Niggas tryna tippy toe through the progress\n','Tonguetied when the truth is an object\n','What''s the pros and cons of this next check?\n','When nobody ''round, I was independent\n','In the 90s, sittin'' bum with the windows tinted\n','Had a bomb, got a strap at the party\n','Where the fuck niggas? At the party\n','Beat ''em up (Bounce), beat ''em up, beat ''em up, beat ''em up (ah)\n','I was seein'' double in the projects\n','Mad at myself when I put it to the side\n','Mama had to cater for the coupe\n','That we rode after school on the way to Popeyes (Bounce)\n','And niggas wanna play both sides\n','It''s a red dot, don''t get on the wrong red eye\n','It''s a headshot, let me get who are them guys\n','Fuck around and bury two of them guys\n','I''m OD in Paris, I''m OD in France\n','I thought that I told you, I need the advance\n','Put down your IG and look through my lens\n','A million to grandma, who did I offend?\n','The girl of your dreams to me is a fan\n','I netted ten million and did a lil'' dance\n','I''m fuckin'' the world, I unzip my pants\n','My uncle G told me that I had a chance\n','So then I popped out and did it again\n','And did it again and did it again\n','I can not respect them, where did he begin?\n','Advice from the council, let nobody in\n','Been swervin'' through rumors\n','Avoidin'' the trends and duckin'' the hoes\n','I''m duckin'' the loonies that come with the shows\n','I''m grateful to Man Man, he opened up doors\n','And bung'' on the tour bus to come and compose\n','I reach to the stars on my tippy toes\n','This greatest success where most niggas fold\n','I tell you my past, that shit don''t get old\n','But how could you ask like I don''t be rappin'' my raps?\n','These critics got everyone tapped\n','You gotta relax, the city where nobody sleep\n','Just tap in and ask where I''m at, ho\n','Smoking on your top five tonight, tonight\n','Yeah, I''m smokin'' on your, what''s her name, tonight, tonight\n','Smokin'' on you, shores, ain''t twonine, yeah, two\n','I am the omega, pgLang, Rollie gang, SIE\n','Don''t you address me unless it''s with four letters\n','I thought you''d known better\n','I been duckin'' the pandemic, I been, social gimmicks\n','I been duckin'' the overnight activists, yeah\n','I''m not a trending topic, I''m a\n','Hold on, y''all niggas playin'' with me, man\n','I am the omega, pgLang, Rollie gang, SIE\n','Don''t you address me unless it''s with four letters\n','Bitch, I thought you''d known better\n','I been duckin'' the pandemic, I been duckin'' the social gimmicks\n','I been duckin'' the overnight actavis, yeah\n','I''m not a trending topic, I''m a prophet\n','I answer to Metatron and Gambriel\n','Bitch, looking for a better me\n','I am a legacy, I come from the seventy\n','The Al Green offspring, guns and the melody\n','The big shot, wrist on cryotherapy\n','Soon as I press that button\n','Nigga better get right like the ambulance comin''\n','Us two on a light, Keem been through nothin''\n','Dave Free got at least one B in the oven\n','I''m trippin'', I''m juugin'', my mental is amazing, brother\n','Pop off, only on occasions, brother\n','Rich nigga, momma know I made it, brother\n','Go figure, never caught cases, brother\n','Face it, brother, gracious brother?\n','New flows comin'', be patient, brother\n','Show my ass and take you out of class\n','I can multitask like Megan, brother\n','2021, I ain''t takin'' no prisoner\n','Last year, y''all fucked up all the listener\n','Who went platinum? I call that a visitor\n','Who the fuck backin'' ''em? All been falsified\n','The facts mean this a vaccine, and the game need me to survive\n','The Elohim, the rebirth\n','Before you get to the Father, you gotta holla at me first, bitch\n','Smokin'' on top fives\n','Motherfuck that album, fuck that single\n','Burn that hard drive (Burn that shit)\n','Ain''t nobody safe\n','When I come up killin'' everybody that''s outside (Who you with?)\n','Yeah, Kanye changed his life\n','But me, I''m still an old school Gemini (Lil'' bitch)\n','Let me jump in this bitch\n','Let me jump in this bitch\n','Two phones, but I only bring one in this bitch\n','One daughter, but they all my sons in this bitch\n','No hoes, ain''t shit gettin'' done in this bitch\n','I''m scary, I got a gun in this bitch\n','Smokin'' on top fives, stop playin'', I''m that guy\n','Number two DM''ing my bitch\n','That''s cool, I don''t ask why'),(SELECT albumID FROM Albums WHERE title = 'The Melodic Blue')),
('Off Deez',131549096,'Hip Hop','C Ukrainian Dorian',NULL,48,58,CONCAT('Gangsta\n','J.I.D, whoa shit, whoa shit, whoa shit\n','ChaseTheMoney, ChaseTheMoney\n','Please, please\n','Get off my dick, get off my dick\n','.40 my hip, loadin'' my clip\n','Cannabis, cannabis, roll up my spliff\n','Hannibal, Hannibal, look what I did\n','Edible, edible, got the munchies\n','But I got the bungees, I''ma jump off this ship\n','But I bet he get whipped with the pistol grip\n','Nigga talkin'' that shit, now I''m talkin'' my shit\n','Get off my dick, get off my dick\n','.40 my hip, loadin'' my clip\n','Cannabis, cannabis, roll up my spliff\n','Hannibal, Hannibal, look what I did\n','Edible, edible, got the munchies\n','But I got the bungees, I''ma jump off this ship\n','But I bet he get whipped with the pistol grip\n','Nigga talkin'' that shit, now I''m talkin'' my shit (Whoa, okay)\n','East Atlanta playboy\n','Don''t got much to say, boy\n','Cradle to the grave, and it''s been like that since a slave, boy\n','It ain''t shit to pull up, pick the fucking tool up\n','Screaming hallelujah, pushing daisies and some tulips (Hi guys, hi, hi, hi)\n','Itty bitty bitch, niggas in the city with it, pull up with a stick\n','Thirty with the dick\n','Seen you in a minute, nigga, put you in cement\n','Anybody get a nigga, anybody get\n','Shouts to the Chi'', nigga poppin'' this shit\n','Got the drop in your crib, in the spot where you live\n','If you talking that shit, nigga, stop it\n','I''m a God, I''m a king, I''m a giant\n','Nigga not trying, .40 my side\n','Eastside guy, but I been worldwide\n','D.I.Y, T.I.Y, I''ma try, I''ma die for what I believe in\n','We like to feast and I try to eat, edible meat\n','I am not an animal, a beast\n','Riding with the hammer on the seat (Oh)\n','Shotgun, shotgun, hand on my heat\n','Bad man, bad man, land of my freedom\n','Nigga get life, let the white folks be\n','Online beef, not my motif\n','.45 me, ta-ta, go sleep\n','Don''t mind little old me, lil'' OG\n','J.I.D, I came in on the boat, see\n','May I be the cold nigga with the most heat\n','Niggas know bro, you don''t know me\n','Get off my dick, get off my dick\n','.40 my hip, loadin'' my clip\n','Cannabis, cannabis, roll up my spliff\n','Hannibal, Hannibal, look what I did\n','Edible, edible, got the munchies\n','But I got the bungees, I''ma jump off this ship\n','But I bet he get whipped with the pistol grip\n','Nigga talkin'' that shit, now I''m talkin'' my shit\n','Get off my dick, get off my dick\n','.40 my hip, loadin'' my clip\n','Cannabis, cannabis, roll up my spliff\n','Hannibal, Hannibal, look what I did\n','Edible, edible, got the munchies\n','But I got the bungees, I''ma jump off this ship (Hey)\n','But I bet he get whipped with the pistol grip (Okay, okay)\n','Nigga talkin'' that shit, now I''m talkin'' my shit (Okay, okay, okay)\n','Legend out the 2-6 (Whoa)\n','Y''all know who the truth is (Whoa)\n','Crazy like a movie by that nigga Stanley Kubrick (Whoa)\n','Perfect time to pop up (Whoa)\n','Wet you like the hot tub (Whoa)\n','Clean up Aisle 7, damn somebody gettin'' mopped up (Whoa)\n','Pull up on the block, eeny, meeny, miny, moe\n','You and every nigga that you know is getting popped\n','Fuckin'' with a nigga, ass sitting in the box\n','Tryna sneak diss, then I''m pickin'' up the Glock\n','I squeeze this, they be pickin'' up the top\n','Styles, Sheek, Kiss, yeah, I''m pickin'' all the locks\n','Pickin'' on a nigga way bigger, then I got\n','Bigger than the nigga that was Kindergarten Cop\n','Terminator shit, I''m a robot\n','With the chrome .45 that most don''t got\n','One false move, get your moto shot\n','Turn a nigga whip to a photo op\n','Click, click, click, and the flows don''t stop\n','''Til I got more cream than Cold Stone got\n','Like a boatload, nigga I''ma float on top\n','''Til the grass don''t grow and the wind don''t blow\n','And the po-po don''t kill niggas no more\n','I bought a thirty round extendo\n','If a nigga wanna duck, then I''m playing Duck Hunt\n','In real life, not on Nintendo\n','Looking out the window like Malcolm X with the rifle\n','Climb the steps up the Eiffel\n','Barely broke a bead of sweat, whoa\n','Many hope to be the best, oh\n','Cannot fuck with me just yet, though\n','J.I.D the closest thing to me\n','C''est la vie, my vocal range putting\n','Blood stains on Notre Dame hoodies\n','Hello fiends, I brought Novocaine plus dopamine\n','You can load your veins with the product I slang\n','Niggas gon'' honor my name, boy, I''m a God in this game\n','Y''all niggas homonyms, sounding the same\n','Not in my lane so I can''t complain\n','Me and Ben Frank got a damn good thing goin'' on\n','Way more than a random fling\n','Cole and J.I.D with a tandem, niggas can''t stand ''em\n','Got a new anthem, look at my whip\n','Slit on my wrist, suicide, suicide doors on my Phantom\n','Get off my dick, get off my dick\n','.40 my hip, loadin'' my clip\n','Cannabis, cannabis, roll up my spliff\n','Hannibal, Hannibal, look what I did\n','Edible, edible, got the munchies\n','But I got the bungees, I''ma jump off this ship\n','But I bet he get whipped with the pistol grip\n','Nigga talkin'' that shit, now I''m talkin'' my shit\n','Get off my dick (Yeah)\n','Get off my dick (Whoa)\n','Get off my dick (Yeah)\n','Get off my dick (Whoa)\n','Get off my dick (Yeah)\n','Get off my dick (Yeah)\n','Get off my dick (Yeah)\n','Get off my dick (Yeah)\n','Get off my dick (Whoa)\n','Get off my dick (Uh)\n','Get off my dick (Yeah)\n','Get off my dick (Get off my)\n','Get off my dick (Yeah)\n','Get off my dick (Whoa)\n','Get off my dick (Yeah)\n','Get off my dick (Whoa)\n','Okay (Sucka!)\n','Something special, J.I.D, Cole, Drama\n','Dreamville (ChaseTheMoney, ChaseTheMoney)'),(SELECT albumID FROM Albums WHERE title = 'DiCaprio 2'));

INSERT INTO SongArtists (songID,artistID)
VALUES ((SELECT songID FROM Songs WHERE name = 'No Role Modelz'),(SELECT artistID FROM Artists WHERE name = 'J. Cole')),
((SELECT songID FROM Songs WHERE name = 'Live Well'),(SELECT artistID FROM Artists WHERE name = 'Palace')),
((SELECT songID FROM Songs WHERE name = '20'),(SELECT artistID FROM Artists WHERE name = 'Magpie Jay')),
((SELECT songID FROM Songs WHERE name = 'family ties'),(SELECT artistID FROM Artists WHERE name = 'Kendrick Lamar')),
((SElECT songID FROM Songs WHERE name = 'family ties'),(SELECT artistID FROM Artists WHERE name = 'Baby Keem')),
((SELECT songID FROM Songs WHERE name = 'Off Deez'),(SELECT artistID FROM Artists WHERE name = 'JID')),
((SELECT songID FROM Songs WHERE name = 'Off Deez'),(SELECT artistID FROM Artists WHERE name = 'J. Cole'));



-- Re-setting startup checks
SET FOREIGN_KEY_CHECKS = 1;
COMMIT;