const List<String> badWords = [
  'abbo', 'abo', 'abortion', 'abuse', 'addict', 'addicts', 'adult', 'africa', 'african',
  'alla', 'allah', 'alligatorbait', 'amateur', 'american', 'anal', 'analannie', 'analsex', 'angie', 'angry', 'anus',
  'arab', 'arabs', 'areola', 'argie', 'aroused', 'arse', 'arsehole', 'asian', 'ass', 'assassin', 'assassinate',
  'assassination', 'assault', 'assbagger', 'assblaster', 'assclown', 'asscowboy', 'asses', 'assfuck', 'assfucker',
  'asshat', 'asshole', 'assholes', 'asshore', 'assjockey', 'asskiss', 'asskisser', 'assklown', 'asslick', 'asslicker',
  'asslover', 'assman', 'assmonkey', 'assmunch', 'assmuncher', 'asspacker', 'asspirate', 'asspuppies', 'assranger', 'asswhore',
  'asswipe', 'athletesfoot', 'attack', 'australian', 'babe', 'babies', 'backdoor', 'backdoorman', 'backseat', 'badfuck',
  'balllicker', 'balls', 'ballsack', 'banging', 'baptist', 'barelylegal', 'barf', 'barface', 'barfface', 'bast', 'bastard',
  'bazongas', 'bazooms', 'beaner', 'beast', 'beastality', 'beastial', 'beastiality', 'beatoff', 'beat-off', 'beatyourmeat',
  'beaver', 'bestial', 'bestiality', 'bi', 'biatch', 'bible', 'bicurious', 'bigass', 'bigbastard', 'bigbutt', 'bigger',
  'bisexual', 'bi-sexual', 'bitch', 'bitcher', 'bitches', 'bitchez', 'bitchin', 'bitching', 'bitchslap', 'bitchy',
  'biteme', 'black', 'blackman', 'blackout', 'blacks', 'blind', 'blow', 'blowjob', 'boang', 'bogan', 'bohunk', 'bollick',
  'bollock', 'bomb', 'bombers', 'bombing', 'bombs', 'bomd', 'bondage', 'boner', 'bong', 'boob', 'boobies', 'boobs', 'booby',
  'boody', 'boom', 'boong', 'boonga', 'boonie', 'booty', 'bootycall', 'bountybar', 'bra', 'brea5t', 'breast', 'breastjob', 'breastlover', 'breastman', 'brothel', 'bugger', 'buggered', 'buggery', 'bullcrap', 'bulldike', 'bulldyke', 'bullshit', 'bumblefuck', 'bumfuck', 'bunga', 'bunghole', 'buried', 'burn', 'butchbabes', 'butchdike', 'butchdyke', 'butt', 'buttbang', 'butt-bang', 'buttface', 'buttfuck', 'butt-fuck', 'buttfucker', 'butt-fucker', 'buttfuckers', 'butt-fuckers', 'butthead', 'buttman', 'buttmunch', 'buttmuncher', 'buttpirate', 'buttplug', 'buttstain', 'byatch', 'cacker', 'cameljockey', 'cameltoe', 'canadian', 'cancer', 'carpetmuncher', 'carruth', 'catholic', 'catholics', 'cemetery', 'chav', 'cherrypopper', 'chickslick', 'chin', 'chinaman', 'chinamen', 'chinese', 'chink', 'chinky', 'choad', 'chode', 'christ', 'christian', 'church', 'cigarette', 'cigs', 'clamdigger', 'clamdiver', 'clit', 'clitoris', 'clogwog', 'cocaine', 'cock', 'cockblock', 'cockblocker', 'cockcowboy', 'cockfight', 'cockhead', 'cockknob', 'cocklicker', 'cocklover', 'cocknob', 'cockqueen', 'cockrider', 'cocksman', 'cocksmith', 'cocksmoker', 'cocksucer', 'cocksuck', 'cocksucked', 'cocksucker', 'cocksucking', 'cocktail', 'cocktease', 'cocky', 'cohee', 'coitus', 'color', 'colored', 'coloured', 'commie', 'communist', 'condom', 'conservative', 'conspiracy', 'coolie', 'cooly', 'coon', 'coondog', 'copulate', 'cornhole', 'corruption', 'cra5h', 'crabs', 'crack', 'crackpipe', 'crackwhore', 'crack-whore', 'crap', 'crapola', 'crapper', 'crappy', 'crash', 'creamy', 'crime', 'crimes', 'criminal', 'criminals', 'crotch', 'crotchjockey', 'crotchmonkey', 'crotchrot', 'cum', 'cumbubble', 'cumfest', 'cumjockey', 'cumm', 'cummer', 'cumming', 'cumquat', 'cumqueen', 'cumshot', 'cunilingus', 'cunillingus', 'cunn', 'cunnilingus', 'cunntt', 'cunt', 'cunteyed', 'cuntfuck', 'cuntfucker', 'cuntlick', 'cuntlicker', 'cuntlicking', 'cuntsucker', 'cybersex', 'cyberslimer', 'dago', 'dahmer', 'dammit', 'damn', 'damnation', 'damnit', 'darkie', 'darky', 'datnigga', 'dead', 'deapthroat', 'death', 'deepthroat', 'defecate', 'dego', 'demon', 'deposit', 'desire', 'destroy', 'deth', 'devil', 'devilworshipper', 'dick', 'dickbrain', 'dickforbrains', 'dickhead', 'dickless', 'dicklick', 'dicklicker', 'dickman', 'dickwad', 'dickweed', 'diddle', 'die', 'died', 'dies', 'dike', 'dildo', 'dingleberry', 'dink', 'dipshit', 'dipstick', 'dirty', 'disease', 'diseases', 'disturbed', 'dive', 'dix', 'dixiedike', 'dixiedyke', 'doggiestyle', 'doggystyle', 'dong', 'doodoo', 'doo-doo', 'doom', 'dope', 'dragqueen', 'dragqween', 'dripdick', 'drug', 'drunk', 'drunken', 'dumb', 'dumbass', 'dumbbitch', 'dumbfuck', 'dyefly', 'dyke', 'easyslut', 'eatballs', 'eatme', 'eatpussy', 'ecstacy', 'ejaculate', 'ejaculated', 'ejaculating', 'ejaculation', 'enema', 'enemy', 'erect', 'erection', 'ero', 'escort', 'ethiopian', 'ethnic', 'european', 'evl', 'excrement', 'execute', 'executed', 'execution', 'executioner', 'explosion', 'facefucker', 'faeces', 'fag', 'fagging', 'faggot', 'fagot', 'failed', 'failure', 'fairies', 'fairy', 'faith', 'fannyfucker', 'fart', 'farted', 'farting', 'farty', 'fastfuck', 'fat', 'fatah', 'fatass', 'fatfuck', 'fatfucker', 'fatso', 'fckcum', 'fear', 'feces', 'felatio', 'felch', 'felcher', 'felching', 'fellatio', 'feltch', 'feltcher', 'feltching', 'fetish', 'fight', 'filipina', 'filipino', 'fingerfood', 'fingerfuck', 'fingerfucked', 'fingerfucker', 'fingerfuckers', 'fingerfucking', 'fire', 'firing', 'fister', 'fistfuck', 'fistfucked', 'fistfucker', 'fistfucking', 'fisting', 'flange', 'flasher', 'flatulence', 'floo', 'flydie', 'flydye', 'fok', 'fondle', 'footaction', 'footfuck', 'footfucker',
  'hooters', 'hore', 'hork', 'horn', 'horney', 'horniest', 'horny', 'horseshit', 'hosejob', 'hoser', 'hostage', 'hotdamn', 'hotpussy', 'hottotrot', 'hummer', 'husky', 'hussy', 'hustler', 'hymen', 'hymie', 'iblowu', 'idiot', 'ikey', 'illegal', 'incest', 'insest', 'intercourse', 'interracial', 'intheass', 'inthebuff', 'israel', 'israeli', 'italiano', 'itch', 'jackass', 'jackoff', 'jackshit', 'jacktheripper', 'jade', 'jap', 'japanese', 'japcrap', 'jebus', 'jeez', 'jerkoff', 'jesus', 'jesuschrist', 'jew', 'jewish', 'jiga', 'jigaboo', 'jigg', 'jigga', 'jiggabo', 'jigger', 'jiggy', 'jihad', 'jijjiboo', 'jimfish', 'jism', 'jiz', 'jizim', 'jizjuice', 'jizm', 'jizz', 'jizzim', 'jizzum', 'joint', 'juggalo', 'jugs', 'junglebunny', 'kaffer', 'kaffir', 'kaffre', 'kafir', 'kanake', 'kid', 'kigger', 'kike', 'kill', 'killed', 'killer', 'killing', 'kills', 'kink', 'kinky', 'kissass', 'kkk', 'knife', 'knockers', 'kock', 'kondum', 'koon', 'kotex', 'krap', 'krappy', 'kraut', 'kum', 'kumbubble', 'kumbullbe', 'kummer', 'kumming', 'kumquat', 'kums', 'kunilingus', 'kunnilingus', 'kunt', 'ky', 'kyke', 'lactate', 'laid', 'lapdance', 'latin', 'lesbain', 'lesbayn', 'lesbian', 'lesbin', 'lesbo', 'lez', 'lezbe', 'lezbefriends', 'lezbo', 'lezz', 'lezzo', 'liberal', 'libido', 'licker', 'lickme', 'lies', 'limey', 'limpdick', 'limy', 'lingerie', 'liquor', 'livesex', 'loadedgun', 'lolita', 'looser', 'loser', 'lotion', 'lovebone', 'lovegoo', 'lovegun', 'lovejuice', 'lovemuscle', 'lovepistol', 'loverocket', 'lowlife', 'lsd', 'lubejob', 'lucifer', 'luckycammeltoe', 'lugan', 'lynch', 'macaca', 'mad', 'mafia', 'magicwand', 'mams', 'manhater', 'manpaste', 'marijuana', 'mastabate', 'mastabater', 'masterbate', 'masterblaster', 'mastrabator', 'masturbate', 'masturbating', 'mattressprincess', 'meatbeatter', 'meatrack', 'meth', 'mexican', 'mgger', 'mggor', 'mickeyfinn', 'mideast', 'milf', 'minority', 'mockey', 'mockie', 'mocky', 'mofo', 'moky', 'moles', 'molest', 'molestation', 'molester', 'molestor', 'moneyshot', 'mooncricket', 'mormon', 'moron', 'moslem', 'mosshead', 'mothafuck', 'mothafucka', 'mothafuckaz', 'mothafucked', 'mothafucker', 'mothafuckin', 'mothafucking', 'mothafuckings', 'motherfuck', 'motherfucked', 'motherfucker', 'motherfuckin', 'motherfucking', 'motherfuckings', 'motherlovebone', 'muff', 'muffdive', 'muffdiver', 'muffindiver', 'mufflikcer', 'mulatto', 'muncher', 'munt', 'murder', 'murderer', 'muslim', 'naked', 'narcotic', 'nasty', 'nastybitch', 'nastyho', 'nastyslut', 'nastywhore', 'nazi', 'necro', 'negro', 'negroes', 'negroid', 'negros', 'nig', 'niger', 'nigerian', 'nigerians', 'nigg', 'nigga', 'niggah', 'niggaracci', 'niggard', 'niggarded', 'niggarding', 'niggardliness', 'niggardlinesss', 'niggardly', 'niggards', 'niggards', 'niggaz', 'nigger', 'niggerhead', 'niggerhole', 'niggers', 'niggers', 'niggle', 'niggled', 'niggles', 'niggling', 'nigglings', 'niggor', 'niggur', 'niglet', 'nignog', 'nigr', 'nigra', 'nigre', 'nip', 'nipple', 'nipplering', 'nittit', 'nlgger', 'nlggor', 'nofuckingway', 'nook', 'nookey', 'nookie', 'noonan', 'nooner', 'nude', 'nudger', 'nuke', 'nutfucker', 'nymph', 'ontherag', 'oral', 'orga', 'orgasim', 'orgasm', 'orgies', 'orgy', 'osama', 'paki', 'palesimian', 'palestinian', 'pansies', 'pansy', 'panti', 'panties', 'payo', 'pearlnecklace', 'peck', 'pecker', 'peckerwood', 'pee', 'peehole', 'pee-pee', 'peepshow', 'peepshpw', 'pendy', 'penetration', 'peni5', 'penile', 'penis', 'penises', 'penthouse', 'period', 'perv', 'phonesex', 'phuk', 'phuked', 'phuking', 'phukked', 'phukking', 'phungky', 'phuq', 'pi55', 'picaninny', 'piccaninny', 'pickaninny', 'piker', 'pikey', 'piky', 'pimp', 'pimped', 'pimper', 'pimpjuic', 'pimpjuice', 'pimpsimp', 'pindick', 'piss', 'pissed', 'pisser', 'pisses', 'pisshead', 'pissin', 'pissing', 'pissoff', 'pistol', 'pixie', 'pixy', 'playboy', 'playgirl', 'pocha', 'pocho', 'pocketpool', 'pohm', 'polack', 'pom', 'pommie', 'pommy', 'poo', 'poon', 'poontang', 'poop', 'pooper', 'pooperscooper', 'pooping', 'poorwhitetrash', 'popimp', 'porchmonkey', 'porn', 'pornflick', 'pornking', 'porno', 'pornography', 'pornprincess', 'pot', 'poverty', 'premature', 'pric', 'prick', 'prickhead', 'primetime', 'propaganda', 'pros', 'prostitute', 'protestant', 'pu55i', 'pu55y', 'pube', 'pubic', 'pubiclice', 'pud', 'pudboy', 'pudd', 'puddboy', 'puke', 'puntang', 'purinapricness', 'puss', 'pussie', 'pussies', 'pussy', 'pussycat', 'pussyeater', 'pussyfucker', 'pussylicker', 'pussylips', 'pussylover', 'pussypounder', 'pusy', 'quashie', 'queef', 'queer', 'quickie', 'quim', 'ra8s', 'rabbi', 'racial', 'racist', 'radical', 'radicals', 'raghead', 'randy', 'rape', 'raped', 'raper', 'rapist', 'rearend', 'rearentry', 'rectum', 'redlight', 'redneck', 'reefer', 'reestie', 'refugee', 'reject', 'remains', 'rentafuck', 'republican', 'rere', 'retard', 'retarded', 'ribbed', 'rigger', 'rimjob', 'rimming', 'roach', 'robber', 'roundeye', 'rump', 'russki', 'russkie',
  's&m', 's.h.i.t.', 's.o.b.', 'sadis', 'sadom', 'samckdaddy', 'sambo', 'satan', 'scag', 'scallywag', 'scat', 'schlong', 'screw', 'screwed', 'scrog', 'scrotum', 'scum', 'semen', 'seppo', 'servant', 'sex', 'sexed', 'sexfarm', 'sexhound', 'sexhouse', 'sexing', 'sexkitten', 'sexpot', 'sexslave', 'sextogo', 'sextoy', 'sextoys', 'sexual', 'sexually', 'sexwhore', 'sexy', 'sexymoma', 'sexy-slim', 'shag', 'shagged', 'shaggin', 'shagging', 'shat', 'shav', 'shaved', 'shawtypimp', 'sheeney', 'shemale', 'shi+', 'shibari', 'shinola', 'shit', 'shitcan', 'shitdick', 'shite', 'shiteater', 'shited', 'shitface', 'shitfaced', 'shitfit', 'shitforbrains', 'shitfuck', 'shitfucker', 'shitfull', 'shithapens', 'shithappens', 'shithead', 'shithouse', 'shiting', 'shitlist', 'shitola', 'shitoutofluck', 'shits', 'shitstain', 'shitted', 'shitter', 'shittiest', 'shitting', 'shitty', 'shoot', 'shooting', 'shortfuck', 'sissy', 'sixsixsix', 'sixtynine', 'sixtyniner', 'skank', 'skankbitch', 'skankfuck', 'skankwhore', 'skanky', 'skankybitch', 'skankywhore', 'skinflute', 'skum', 'skumbag', 'slanteye', 'slanty', 'slave', 'slavedriver', 'sleezebag', 'sleezeball', 'slideitin', 'slime', 'slimeball', 'slimebucket', 'slopehead', 'sloper', 'slopies', 'slopy', 'slut', 'slutbag', 'slutdumper', 'slutkiss', 'sluts', 'slutt', 'slutting', 'slutty', 'slutwear', 'slutwhore', 'smack', 'smackthemonkey', 'smartass', 'smartasses', 'smartone', 'smear', 'smoker', 'smut', 'snatch', 'snatchpatch', 'snigger', 'sniggered', 'sniggering', 'sniggers', 'snigger\'s', 'sniper', 'snot', 'snowback', 'snownigger', 'snuff', 'sob', 'sodom', 'sodomise', 'sodomite', 'sodomize', 'sodomy', 'sonofabitch', 'sooty', 'sos', 'spac', 'spade', 'spank', 'spankthemonkey', 'sperm', 'spearchucker', 'spearchuckers', 'spec', 'spic', 'spick', 'spig', 'spigotty', 'spik', 'spit', 'spitter', 'splittail', 'spooge', 'spreadeagle', 'spunk', 'spunky', 'sqeh', 'squaw', 'stagg', 'stiffy', 'strapon', 'stringer', 'stripclub', 'stroke', 'stroking', 'stupid', 'stupidfuck', 'stupidfucker', 'suck', 'suckdick', 'sucked', 'sucking', 'sucks', 'suicide', 'swallower', 'swampguinea', 'swastika', 'swinger', 'syphilis', 'taboo', 'tacohead', 'taff', 'taig', 'tampon', 'tantra', 'tarbaby', 'tard', 'teat', 'terror', 'terrorist', 'teste', 'testicle', 'testicles', 'thicklip', 'thirdeye', 'thirdleg', 'threesome', 'threeway', 'timbernigger', 'tinkle', 'tit', 'titbitnipply', 'titfuck', 'titfucker', 'titfuckin', 'titjob', 'titlicker', 'titlover', 'tits', 'tittie', 'titties', 'titty', 'tittyfuck', 'tittyfucker', 'tittys', 'toilet', 'tongethruster', 'tongue', 'tonguethrust', 'tonguetramp', 'tortur', 'torture', 'tosser', 'towelhead', 'trailertrash', 'tramp', 'trannie', 'tranny', 'transsexual', 'transvestite', 'triplex', 'trisexual', 'trojan', 'trots', 'tuckahoe', 'tunneloflove', 'turd', 'turnon', 'twat', 'twathead', 'twatlips', 'twats', 'twatty', 'twink', 'twinkie', 'twobitwhore', 'uck', 'uk', 'ukrop', 'unclefucker', 'undies', 'undressing', 'unfuckable', 'upskirt', 'uptheass', 'upthebutt', 'urinal', 'urinary', 'urinate', 'urine', 'uterus', 'vagina', 'valium', 'vibr', 'vibrater', 'vibrator', 'vietcong', 'violate', 'violation', 'virgin', 'vixen', 'vodka', 'vomit', 'voyeur', 'vulva', 'wab', 'wank', 'wanker', 'wanking', 'waysted', 'wazoo', 'wedgie', 'weed', 'weenie', 'weewee', 'welcher', 'wench', 'wetb', 'wetback', 'wetspot', 'whacker', 'whash', 'whigger', 'whiggers', 'whisky', 'whiskydick', 'whisper', 'whist', 'whit', 'whitenigger', 'whites', 'whitetrash', 'whitey', 'whiz', 'whop', 'whore', 'whorefucker', 'whorehouse', 'wigger', 'willie', 'williewanker', 'willy', 'wn', 'wog', 'wop', 'wrappingmen', 'wrinkledstarfish', 'wtf', 'wuss', 'wuzzie', 'xkwe', 'xxx', 'yaoi', 'yarpie', 'yid', 'yobbo', 'zibbi', 'zipperhead', 'zoophile', 'zoophilia', 'zoosexual', 'zulu', 'zzzchink'
  //different word list
      '4r5e', '5h1t', '5hit', 'a55', 'anal', 'anus', 'ar5e', 'arrse', 'arse', 'ass', 'ass-fucker', 'asses', 'assfucker', 'assfukka', 'asshole', 'assholes', 'asswhole', 'a_s_s', 'b!tch', 'b00bs', 'b17ch', 'b1tch', 'ballbag', 'balls', 'ballsack', 'bastard', 'beastial', 'beastiality', 'bellend', 'bestial', 'bestiality', 'bi+ch', 'biatch', 'bitch', 'bitcher', 'bitchers', 'bitches', 'bitchin', 'bitching', 'bloody', 'blow job', 'blowjob', 'blowjobs', 'boiolas', 'bollock', 'bollok', 'boner', 'boob', 'boobs', 'booobs', 'boooobs', 'booooobs', 'booooooobs', 'breasts', 'buceta', 'bugger', 'bum', 'bunny fucker', 'butt', 'butthole', 'buttmuch', 'buttplug', 'c0ck', 'c0cksucker', 'carpet muncher', 'cawk', 'chink', 'cipa', 'cl1t', 'clit', 'clitoris', 'clits', 'cnut', 'cock', 'cock-sucker', 'cockface', 'cockhead', 'cockmunch', 'cockmuncher', 'cocks', 'cocksuck', 'cocksucked', 'cocksucker', 'cocksucking', 'cocksucks', 'cocksuka', 'cocksukka', 'cok', 'cokmuncher', 'coksucka', 'coon', 'cox', 'crap', 'cum', 'cummer', 'cumming', 'cums', 'cumshot', 'cunilingus', 'cunillingus', 'cunnilingus', 'cunt', 'cuntlick', 'cuntlicker', 'cuntlicking', 'cunts', 'cyalis', 'cyberfuc', 'cyberfuck', 'cyberfucked', 'cyberfucker', 'cyberfuckers', 'cyberfucking', 'd1ck', 'damn', 'dick', 'dickhead', 'dildo', 'dildos', 'dink', 'dinks', 'dirsa', 'dlck', 'dog-fucker', 'doggin', 'dogging', 'donkeyribber', 'doosh', 'duche', 'dyke', 'ejaculate', 'ejaculated', 'ejaculates', 'ejaculating', 'ejaculatings', 'ejaculation', 'ejakulate', 'f u c k', 'f u c k e r', 'f4nny', 'fag', 'fagging', 'faggitt', 'faggot', 'faggs', 'fagot', 'fagots', 'fags', 'fanny', 'fannyflaps', 'fannyfucker', 'fanyy', 'fatass', 'fcuk', 'fcuker', 'fcuking', 'feck', 'fecker', 'felching', 'fellate', 'fellatio', 'fingerfuck', 'fingerfucked', 'fingerfucker', 'fingerfuckers', 'fingerfucking', 'fingerfucks', 'fistfuck', 'fistfucked', 'fistfucker', 'fistfuckers', 'fistfucking', 'fistfuckings', 'fistfucks', 'flange', 'fook', 'fooker', 'fuck', 'fucka', 'fucked', 'fucker', 'fuckers', 'fuckhead', 'fuckheads', 'fuckin', 'fucking', 'fuckings', 'fuckingshitmotherfucker', 'fuckme', 'fucks', 'fuckwhit', 'fuckwit', 'fudge packer', 'fudgepacker', 'fuk', 'fuker', 'fukker', 'fukkin', 'fuks', 'fukwhit', 'fukwit', 'fux', 'fux0r', 'f_u_c_k', 'gangbang', 'gangbanged', 'gangbangs', 'gaylord', 'gaysex', 'goatse', 'God', 'god-dam', 'god-damned', 'goddamn', 'goddamned', 'hardcoresex', 'hell', 'heshe', 'hoar', 'hoare', 'hoer', 'homo', 'hore', 'horniest', 'horny', 'hotsex', 'jack-off', 'jackoff', 'jap', 'jerk-off', 'jism', 'jiz', 'jizm', 'jizz', 'kawk', 'knob', 'knobead', 'knobed', 'knobend', 'knobhead', 'knobjocky', 'knobjokey', 'kock', 'kondum', 'kondums', 'kum', 'kummer', 'kumming', 'kums', 'kunilingus', 'l3i+ch', 'l3itch', 'labia', 'lmfao', 'lust', 'lusting', 'm0f0', 'm0fo', 'm45terbate', 'ma5terb8', 'ma5terbate', 'masochist', 'master-bate', 'masterb8', 'masterbat*', 'masterbat3', 'masterbate', 'masterbation', 'masterbations', 'masturbate', 'mo-fo', 'mof0', 'mofo', 'mothafuck', 'mothafucka', 'mothafuckas', 'mothafuckaz', 'mothafucked', 'mothafucker', 'mothafuckers', 'mothafuckin', 'mothafucking', 'mothafuckings', 'mothafucks', 'mother fucker', 'motherfuck', 'motherfucked', 'motherfucker', 'motherfuckers', 'motherfuckin', 'motherfucking', 'motherfuckings', 'motherfuckka', 'motherfucks', 'muff', 'mutha', 'muthafecker', 'muthafuckker', 'muther', 'mutherfucker', 'n1gga', 'n1gger', 'nazi', 'nigg3r', 'nigg4h', 'nigga', 'niggah', 'niggas', 'niggaz', 'nigger', 'niggers', 'nob', 'nob jokey', 'nobhead', 'nobjocky', 'nobjokey', 'numbnuts', 'nutsack', 'orgasim', 'orgasims', 'orgasm', 'orgasms', 'p0rn', 'pawn', 'pecker', 'penis', 'penisfucker', 'phonesex', 'phuck', 'phuk', 'phuked', 'phuking', 'phukked', 'phukking', 'phuks', 'phuq', 'pigfucker', 'pimpis', 'piss', 'pissed', 'pisser', 'pissers', 'pisses', 'pissflaps', 'pissin', 'pissing', 'pissoff', 'poop', 'porn', 'porno', 'pornography', 'pornos', 'prick', 'pricks', 'pron', 'pube', 'pusse', 'pussi', 'pussies', 'pussy', 'pussys', 'rectum', 'retard', 'rimjaw', 'rimming', 's hit', 's.o.b.', 'sadist', 'schlong', 'screwing', 'scroat', 'scrote', 'scrotum', 'semen', 'sex', 'sh!+', 'sh!t', 'sh1t', 'shag', 'shagger', 'shaggin', 'shagging', 'shemale', 'shi+', 'shit', 'shitdick', 'shite', 'shited', 'shitey', 'shitfuck', 'shitfull', 'shithead', 'shiting', 'shitings', 'shits', 'shitted', 'shitter', 'shitters', 'shitting', 'shittings', 'shitty', 'skank', 'slut', 'sluts', 'smegma', 'smut', 'snatch', 'son-of-a-bitch', 'spac', 'spunk', 's_h_i_t', 't1tt1e5', 't1tties', 'teets', 'teez', 'testical', 'testicle', 'tit', 'titfuck', 'tits', 'titt', 'tittie5', 'tittiefucker', 'titties', 'tittyfuck', 'tittywank', 'titwank', 'tosser', 'turd', 'tw4t', 'twat', 'twathead', 'twatty', 'twunt', 'twunter', 'v14gra', 'v1gra','vagina', 'viagra', 'vulva', 'w00se', 'wang', 'wank', 'wanker', 'wanky', 'whoar', 'whore', 'willies', 'willy', 'xrated', 'xxx'
  //differne word list
  'aand', 'aandu', 'balatkar', 'balatkari', 'behen chod', 'beti chod', 'bhadva', 'bhadve', 'bhandve', 'bhangi', 'bhootni ke', 'bhosad', 'bhosadi ke', 'boobe', 'chakke', 'chinaal', 'chinki', 'chod', 'chodu', 'chodu bhagat', 'chooche', 'choochi', 'choope', 'choot', 'choot ke baal', 'chootia', 'chootiya', 'chuche', 'chuchi', 'chudaap', 'chudai khanaa', 'chudam chudai', 'chude', 'chut', 'chut ka chuha', 'chut ka churan', 'chut ka mail', 'chut ke baal', 'chut ke dhakkan', 'chut maarli', 'chutad', 'chutadd', 'chutan', 'chutia', 'chutiya', 'gaand', 'gaandfat', 'gaandmasti', 'gaandufad', 'gandfattu', 'gandu', 'gashti', 'gasti', 'ghassa', 'ghasti', 'gucchi', 'gucchu', 'harami', 'haramzade', 'hawas', 'hawas ke pujari', 'hijda', 'hijra', 'jhant', 'jhant chaatu', 'jhant ka keeda', 'jhant ke baal', 'jhant ke pissu', 'jhantu', 'kamine', 'kaminey', 'kanjar', 'kutta', 'kutta kamina', 'kutte ki aulad', 'kutte ki jat', 'kuttiya', 'loda', 'lodu', 'lund', 'lund choos', 'lund ka bakkal', 'lund khajoor', 'lundtopi', 'lundure', 'maa ki chut', 'maal', 'madar chod', 'madarchod', 'madhavchod', 'mooh mein le', 'mutth', 'mutthal', 'najayaz', 'najayaz aulaad', 'najayaz paidaish', 'paki', 'pataka', 'patakha', 'raand', 'randaap', 'randi', 'randi rona', 'saala', 'saala kutta', 'saali kutti', 'saali randi', 'suar', 'suar ke lund', 'suar ki aulad', 'tatte', 'tatti', 'teri maa ka bhosada', 'teri maa ka boba chusu', 'teri maa ki behenchod', 'teri maa ki chut', 'tharak', 'tharki', 'tu chuda',
  'gaandfat', 'gaandmasti', 'gaandufad', 'gandfattu', 'gandu', 'gashti', 'gasti', 'ghassa', 'ghasti', 'gucchi', 'gucchu', 'harami', 'haramzade', 'hawas', 'hawas ke pujari', 'hijda', 'hijra', 'jhant', 'jhant chaatu', 'jhant ka keeda', 'jhant ke baal', 'jhant ke pissu', 'jhantu', 'kamine', 'kaminey', 'kanjar', 'kutta', 'kutta kamina', 'kutte ki aulad', 'kutte ki jat', 'kuttiya', 'loda', 'lodu', 'lund', 'lund choos', 'lund ka bakkal', 'lund khajoor', 'lundtopi', 'lundure', 'maa ki chut', 'maal', 'madar chod', 'madarchod', 'madhavchod', 'mooh mein le', 'mutth', 'mutthal', 'najayaz', 'najayaz aulaad', 'najayaz paidaish', 'paki', 'pataka', 'patakha', 'raand', 'randaap', 'randi', 'randi rona', 'saala', 'saala kutta', 'saali kutti', 'saali randi', 'suar', 'suar ke lund', 'suar ki aulad', 'tatte', 'tatti', 'teri maa ka bhosada', 'teri maa ka boba chusu', 'teri maa ki behenchod', 'teri maa ki chut', 'tharak', 'tharki', 'tu chuda',
  'balatkar', 'balatkari', 'behen chod', 'beti chod', 'bhadva', 'bhadve', 'bhandve', 'bhangi', 'bhootni ke', 'bhosad', 'bhosadi ke', 'boobe', 'chakke', 'chinaal', 'chinki', 'chod', 'chodu', 'chodu bhagat', 'chooche', 'choochi', 'choope', 'choot', 'choot ke baal', 'chootia', 'chootiya', 'chuche', 'chuchi', 'chudaap', 'chudai khanaa', 'chudam chudai', 'chude', 'chut', 'chut ka chuha', 'chut ka churan', 'chut ka mail', 'chut ke baal', 'chut ke dhakkan', 'chut maarli', 'chutad', 'chutadd', 'chutan', 'chutia', 'chutiya', 'gaand', 'gaandfat', 'gaandmasti', 'gaandufad', 'gandfattu', 'gandu', 'gashti', 'gasti', 'ghassa', 'ghasti', 'gucchi', 'gucchu', 'harami', 'haramzade', 'hawas', 'hawas ke pujari', 'hijda', 'hijra', 'jhant', 'jhant chaatu', 'jhant ka keeda', 'jhant ke baal', 'jhant ke pissu', 'jhantu', 'kamine', 'kaminey', 'kanjar', 'kutta', 'kutta kamina', 'kutte ki aulad', 'kutte ki jat', 'kuttiya', 'loda', 'lodu', 'lund', 'lund choos', 'lund ka bakkal', 'lund khajoor', 'lundtopi', 'lundure', 'maa ki chut', 'maal', 'madar chod', 'madarchod', 'madhavchod', 'mooh mein le', 'mutth', 'mutthal', 'najayaz', 'najayaz aulaad', 'najayaz paidaish', 'paki', 'pataka', 'patakha', 'raand', 'randaap', 'randi', 'randi rona', 'saala', 'saala kutta', 'saali kutti', 'saali randi', 'suar', 'suar ke lund', 'suar ki aulad', 'tatte', 'tatti', 'teri maa ka bhosada', 'teri maa ka boba chusu', 'teri maa ki behenchod', 'teri maa ki chut', 'tharak', 'tharki', 'tu chuda'
  //different word list
  'aand mat kaha', 'baap ke lavde', 'chodu',
  'laude',
  'behend kae lund',
  'bsdk',
  'teri ma ki',
  'teri ma ka',
  'chooth',
  'teri ma ka bhosda',
  'lunndd',
  'lundddd',
  'chodoo',
  'choodu',
  'gandu',
  'gaandu',
  'gandoo',
  'bhosad',
  'bhosada',
  'bhosadaa',
  'bhosadaaa',
  'bhosadii',
  'bhosadika',
  'bhosadike',
  'bhosadiki',
  'bosadike',
  'bakrichod',
  'balatkaar',
  'behen ke laude',
  'betichod',
  'bhai chhod',
  'bhayee chod',
  'bhen chhod',
  'bhaynchod',
  'behanchod',
  'behenchod',
  'bhen ke lode',
  'bhosdi',
  'bhosdike',
  'chipkai ki choot ke paseene',
  'cha cha chod',
  'ch*d ke bal ka kida',
  'chopre he randi',
  'chudasi',
  'chut ka maindak',
  'chutia',
  'chutiya',
  'chootia',
  'chutiye',
  'dheeli choot',
  'choot',
  'chootiya',
  'gaand chaat mera',
  'gaand',
  'gaand ka khadda',
  'gaand ke dhakan',
  'gaand mein kida',
  'gandi chut mein sadta hua ganda kida',
  'gandmasti',
  'jhaat ke baal',
  'jhat lahergaya',
  'jhatoo',
  'jhantu',
  'kukarchod',
  'kutha sala',
  'kuthta buraanahe kandaa nahi pattaahe',
  'lode jesi shakal ke',
  'lode ke baal',
  'lund khajoor',
  'lund chuse',
  'lund',
  'luhnd',
  'lundh',
  'madar chod',
  'maadarchod',
  'maadar',
  'madar',
  'ch*d',
  'madarchod',
  'madarchod ke aulaad',
  'mader chod',
  'mai ch*d',
  'mera mume le',
  'mere fudi kha ley',
  'meri ghand ka baal',
  'randi',
  'randi ka choda',
  'suzit',
  'sust lund ki padaish',
  'tatti ander lele',
  'tere baap ki gaand',
  'teri chute mai chuglee',
  'teri gaand mein haathi ka lund',
  'teri maa ki choot',
  'teri maa ki sukhi bhos',
  'teri phuphi ki choot mein',
  'teri bhosri mein aag',
  'teri gaand me danda',
  'teri ma ki choot me bara sa land',
  'teri ma ki chudaye bandar se hui',
  'teri ma randi',
  'teri maa ke bable',
  'teri maa ke bhosade ke baal',
  'tu tera maa ka lauda',
  'amma ki chut',
  'bhaand me jaao',
  'bhadva',
  'bhadve',
  'ch*dika',
  'bhadwe ki nasal',
  'bhen ke lode maa chuda',
  'bhosad ch*d',
  'bhosadch*d',
  'bhosadi ke',
  'bhosdee kay',
  'bhosdi k',
  'bulle ke baal',
  'bursungha',
  'camina',
  'ch*d bhangra',
  'choot k bhoot',
  'choot k pakode',
  'choot ka paani',
  'choot ka pissu',
  'choot ki jhilli',
  'chudpagal',
  'chut ke makkhan',
  'chootiye',
  'gaand maar bhen ch*d',
  'gand mein louda',
  'gandi fuddi ki gandi auladd',
  'haram zaadaa',
  'harami',
  'jhaat',
  'kaala lund',
  'kaali kutti',
  'kuthri',
  'kutte',
  'kutte ki olad',
  'lavde ka baal',
  'lavde',
  'lodu',
  'lowde ka bal',
  'lund k laddu',
  'lund mera muh tera',
  'maa-cho',
  'maal ch*dna',
  'mahder ch*d',
  'mera gota moo may lay',
  'mome ka pasina chat',
  'moo may lay mera',
  'padosi ki aulaad',
  'rand ki moot',
  'randi baj',
  'randi ka larka',
  'randi ke bacche',
  'randi ke beej',
  'saale lm',
  'sab ka lund teri ma ki chut mein',
  'sinak se paida hua',
  'suvar ch*d',
  'suwar ki aulad',
  'tera gittha',
  'tere maa ka bur',
  'teri behen ka bhosda faadu',
  'teri gand mai ghadhe ka lund',
  'teri ma bahar chud rahi he',
  'teri ma ko kutta chode',
  'teri maa ka bhosra',
  'teri maa ka boba chusu',
  'teri maa ki choot me kutte ka lavda',
  'teri maa ki chut',
  'teri maa ki chute',
  'tuzya aaichi kanda puchi',
  'bhadavya',
  'bhikaar',
  'bulli',
  'chinaal',
  'ch*t',
  'gaand',
  'maadarbhagat',
  'ch*dubhagat',
  'lundfakir',
  'gandit',
  'jhavadya',
  'laudu',
  'lavadya',
  'muttha',
  'raandichya',
  'madarchoth'
  //different wordlist
      'chutiya',
  'chutiy',
  'chutyaa',
  'chutiyah',
  'chutiyai',
  'chutiyan',
  'chutiyapan',
  'chutiyappa',
  'chutiyapanti',
  'chutiyapana',
  'chutiyagiri',
  'chutiyafaramoshi',
  'chutiyal',
  'chutiyalal',
  'chutiyashree',
  'chutiyachaap',
  'chutiyachaap',
  'chutiyajaat',
  'chutiyamandal',
  'chutiyakranti',
  'chutiyadev',
  'chutiyavallabh',
  'chutiyalal',
  'randi',
  'raandi',
  'raandee',
  'raandii',
  'raand',
  'raandiii',
  'randee',
  'randiii',
  'randeez',
  'randiv',
  'randevi',
  'randik',
  'randii',
  'randikai',
  'randipur',
  'randigiri',
  'randipan',
  'randipanti',
  'randiveda',
  'randipath',
  'madar chod',
  'maadar chod',
  'maaadar chod',
  'mader chod',
  'madhar chod',
  'madarchod',
  'maadarchod',
  'madhar-chod',
  'madaar-chod',
  'madar-chhod',
  'maadar-chhod',
  'mader-chod',
  'mader-chhod',
  'madhar-chhod',
  'maadar chhod',
  'madarachod',
  'maadarchod',
  'maddarchod',
  'madr chod',
  'maadr chod',
  'maderchode',
  'madarchode',
  'madarchhod',
  'maadar-chhod',
  'madarachhod',
  'madrchod',
  'maadar-chod',
  'madr-chod',
  'madhar-chod',
  'madhar chhod',
  'madaar-chhod'
];
