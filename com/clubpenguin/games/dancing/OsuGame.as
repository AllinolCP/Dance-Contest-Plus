import mx.utils.Delegate;

class com.clubpenguin.games.dancing.OsuGame
{
	var downloaded, movie, hasDownloaded, charts, notes, noteTimes, noteLengths, AudioFilename, playtime_seconds, engine, menuSystem;

	function OsuGame(engine, movie) {
	
		this.downloaded = false;
		this.playing = false;
		this.movie = null;
		this.fileName = null;
		this.charts = new Array();
		this.notes = new Array();
		this.noteTimes = null;
		this.noteLengths = null;
		this.AudioFilename = null;
		this.playtime_seconds = null;
		
		this.movie = movie;
		this.engine = engine;
		
		_global.osuEngine = this;
	
	}
	
	function loadMenu(parent, buttonId) {
		this.menuSystem = parent;
	
		if(this.fileName == 'epicgamerfail') {
			trace(this.fileName);
			this.fileName = null;
			
			parent.loadMenu(com.clubpenguin.games.dancing.MenuSystem.MENU_OSU_URL);
		}
		
		if(this.downloaded && buttonId != undefined){
			this.convertSongAndPlay(parent, buttonId);
		} else {
			this.menuIntro(parent, buttonId)
		}
	
	}
	function onDownloaded(success:Boolean):Void {
		var menuMovie = this.menuSystem.movie;
		var charts = new Array();
		if (!success) {
			trace("Error connecting to server.");
			menuMovie.loading._visible = false;
			menuMovie.host.animation.movie.gotoAndPlay("talkStart");
			menuMovie.speech.message.text = "Oops! That didn't work!\nUnfortunately maps that don't have a leaderboard cannot be used at this time.";
			for (var i = 1; i <= 5; ++i)
			{
				if (menuMovie.speech.message.textHeight < (i * 24) + 12)
				{
					menuMovie.speech.bubble._height = 80 + (i * 12);
				} // end if
			} // end of for
			this.fileName = 'epicgamerfail';
			break;
		} else {
		   trace(result_dl.charts.split('.osu'));
		   charts = result_dl.charts.split('.osu');
		   for(i=(charts.length); i>=0; i--)
		   {
				if (charts[i] == "")
				charts.splice(i,1);
		   }
		   this.charts = charts;
		   trace(result_dl.fileName);
		   fileName = result_dl.fileName;
		   this.fileName = result_dl.fileName;
		   var beatmapID = urlSubmitted.split('https://osu.ppy.sh/beatmapsets/')[1].split('#')[0];
		   var rawFileName = fileName.split(beatmapID + " ")[1];
		   this.menuSystem.currentMenu = 692;
		   this.downloaded = true;
		   menuMovie.host.animation.movie.gotoAndPlay("talkStart");
		   trace("current menu is " + currentMenu);
		   menuMovie.loading._visible = false;
		   menuMovie.speech.message.text = "Successfully downloaded " + rawFileName.split(".osz")[0] + "!\nPlease pick a beatmap";
			for (var i = 1; i <= 5; ++i)
			{
				if (menuMovie.speech.message.textHeight < (i * 24) + 12)
				{
					menuMovie.speech.bubble._height = 80 + (i * 12);
				} // end if
			} // end of for
			var _loc6 = 3.500000E+000;
			trace("charts lenghts = " + charts.length);
			menuMovie.options.background._height = charts.length * 27 + (charts.length - 1) * _loc6 + 14;
			menuMovie.options.background._y = (-30.5 * (charts.length)) + 122;
			var _loc2 = 0;
			while (_loc2++ < 9)
			{
				var pointer = "item" + String(_loc2);
				trace(pointer);
				menuMovie.options[pointer]._visible = false;
			} // end while
			for (var _loc2 = 0; _loc2 < charts.length; ++_loc2)
			{
				var pointer = "item" + String(_loc2 + 1);
				menuMovie.options[pointer].label.text = charts[_loc2];
				trace(pointer);
				menuMovie.options[pointer]._visible = true;
				menuMovie.options[pointer]._y = (_loc2 - 1) * 30.5 - (((charts.length - 5) * 30.5) - 7);
			} // end of for
			menuMovie.options._visible = true;
			menuMovie.options.urlInput._visible = false;
			menuMovie.howtoplay._visible = false;
			menuMovie.howtoplay.gotoAndStop(1);
			talking = false;
			break;
		}
	}
	function menuIntro(menuSystem, buttonId) {
		_global.dls_dance._seenInstructions = false;
		switch(buttonId) {
			case 1:
			{
				trace("url submitted " + menuSystem.movie.options.urlInput.urlInputText.text);
				var urlSubmitted = menuSystem.movie.options.urlInput.urlInputText.text;
				var send_dl:LoadVars = new LoadVars();
				var result_dl:LoadVars = new LoadVars();

				result_dl.onLoad = Delegate.create(this, onDownloaded);

				var mapId = urlSubmitted.split('https://osu.ppy.sh/beatmapsets/')[1].split("#")[0]; //supposidly you can use the osu! api to grab DL links to but i could never figure it out, so hopefully this site never goes down lol
				trace(mapId);
				if(mapId == undefined) return;
				
				menuSystem.movie.loading._visible = true;
				menuSystem.movie.host.animation.movie.gotoAndPlay("talkStart");
				menuSystem.showSpeechBubble("Downloading beatmap...\nPlease wait...");
				menuSystem.hideMenuOptions();
				try {
					send_dl.sendAndLoad('https://dance-contest-plus-plus.herokuapp.com/getOsuMap?mapId=' + mapId, result_dl, 'POST');
				} catch (e){
					trace(e);
				}
				
			}
			break;
			case 2:
			{
				menuSystem.loadMenu(com.clubpenguin.games.dancing.MenuSystem.MENU_WELCOME_OPTIONS);
				return;
			}
			default:
				return;
			
		
		}
	
	}
	
	function convertSongAndPlay(parent, buttonId) {
		this.playing = true;
		trace("button id is " + buttonId)
		trace("fuck my life");
		var send_lv:LoadVars = new LoadVars();
		var result_lv:LoadVars = new LoadVars();

		send_lv.sendAndLoad('https://dance-contest-plus-plus.herokuapp.com/convertOsuToDC?fileName=' + this.fileName + '&chart=' + this.charts[(buttonId - 1)], result_lv, 'POST');
		
		trace('https://dance-contest-plus-plus.herokuapp.com/convertOsuToDC?fileName=' + this.fileName + '&chart=' + this.charts[(buttonId - 1)]);
		parent.movie.loading._visible = true;
		parent.showSpeechBubble("Converting beatmap...\nPlease wait...");
		parent.hideMenuOptions();
		parent.movie.howtoplay._visible = false;
		parent.movie.howtoplay.gotoAndStop(1);
		
		result_lv.onLoad = Delegate.create(this, onConverted);
	}
	
	function startGame() {
		trace("succ");
        _global.dls_dance.startSong();
        this.engine.noteManager.destroy();
        var _loc5;
		this.engine.noteManager.init(this.notes, this.noteTimes, this.noteLengths, 1250);
		_loc5 = 2000 / com.clubpenguin.games.dancing.AnimationEngine.TOTAL_DANCE_FRAMES;
        this.engine.keyPresses = new Array();
        this.engine.animationEngine.startSong(_loc5);
        this.engine.startTimer();
        this.engine.currentRating = com.clubpenguin.games.dancing.GameEngine.MAX_RATING / 2;
        this.engine.consecutiveNotes = 0;
        this.engine.currentMultiplier = 1;
        this.engine.currentScore = 0;
        this.engine.statsLongestChain = 0;
        this.engine.statsNotesHit = 0;
        this.engine.statsNoteBreakdown = [0, 0, 0, 0, 0, 0];
        this.engine.statsTotalNotes = this.notes.length;
        if (com.clubpenguin.games.dancing.GameEngine.SHELL == undefined)
        {
            this.engine.SHELL = global.getCurrentShell();
        } // end if
        com.clubpenguin.games.dancing.GameEngine.SHELL.stopMusic();
		//this.AudioFilename.start();
		var timer = setInterval(function () {this.AudioFilename.start(); clearInterval(timer)}, this.AudioLeadIn);
        this.engine.handleScoreUpdate(Number.MAX_VALUE);
        this.engine.isPlayingGame = true;
        this.engine.isDancing = true;
	}
	
	function onConverted(success) {
	   this.notes = result_lv.notes.split(',');
	   this.noteTimes = result_lv.noteTimes.split(',');
	   this.noteLengths = result_lv.noteLengths.split(',');
	   var menuMovie = this.menuSystem.movie;
	   var AudioFilename2 = result_lv.AudioFilename;
	   this.playtime_seconds = result_lv.playtime_seconds;
	   this.AudioLeadIn = 0;
	   if (result_lv.AudioLeadIn != null)
	   {
			this.AudioLeadIn = result_lv.AudioLeadIn;
	   }
	   trace(this.AudioFilename);
	   trace(this.AudioLeadIn);
	   trace("playtime_seconds " + this.playtime_seconds);
	   this.AudioFilename = new Sound();
	   this.AudioFilename.onLoad = Delegate.create(this, onAudioLoad)
	   this.AudioFilename.loadSound("https://dance-contest-plus-plus.herokuapp.com/tmp/" + this.fileName.substr(0, this.fileName.length-4) + "/" + AudioFilename2, false);
	
	}
	
	function onAudioLoad(success) {
		var menuMovie = this.menuSystem.movie;
		if (!success) {
			trace("Error connecting to server.");
			menuMovie.loading._visible = false;
			menuMovie.host.animation.movie.gotoAndPlay("talkStart");
			menuMovie.speech.message.text = "Oops! That didn't work!\nTry exiting and re-entering Dance Contest and try again.";
			for (var i = 1; i <= 5; ++i)
			{
				if (menuMovie.speech.message.textHeight < (i * 24) + 12)
				{
					menuMovie.speech.bubble._height = 80 + (i * 12);
				} // end if
			} // end of for
			this.fileName = null;
			break;	
	   } else {
		   menuMovie.host.gotoAndStop("exit");
		   this.menuSystem.hideSpeechBubble();
		   menuMovie.speech._visible = false;
		   menuMovie.options._visible = false;
		   menuMovie.loading._visible = false;
		   menuMovie.howtoplay._visible = false;
		   menuMovie.howtoplay.gotoAndStop(1);
		   break;
	   }
	}
	

	function destroy() {
		var send_rm:LoadVars = new LoadVars();
		var result_rm:LoadVars = new LoadVars();
		send_rm.sendAndLoad('https://dance-contest-plus-plus.herokuapp.com/cleanup?fileName=' + this.fileName, result_rm, 'POST');

		this.playing =false;
		this.movie = null;
		this.downloaded = false;
		this.fileName = null;
		this.charts = null;
		this.notes = null;
		this.noteTimes = null;
		this.noteLengths = null;
		this.AudioFilename = null;
		this.playtime_seconds = null;
		break;
	}


}