let Hooks = {}

Hooks.Player = {
    videoId() {
        return this.el.getAttribute("video-id");
    },

    randString() {
        return (Math.random() + 1).toString(36).substring(2);
    },

    mounted() {
        window.sessionId = this.randString();
        window.player = new YT.Player('player', {
            height: '100%',
            width: '100%',
            videoId: this.videoId(),
            border: 0,
            playerVars: {
                'autoplay': 1,
                'mute': 1,
            },
            events: {
                'onReady': onPlayerReady,
                'onStateChange': onPlayerStateChange
            }
        });

        // register lobby channel event handlers
        lobbyChannel.on("play", payload => onChannelPlay(payload))
        lobbyChannel.on("pause", payload => onChannelPause(payload))

        function onPlayerReady(event) {
            event.target.playVideo();
        }

        function onPlayerStateChange(event) {
            let payload = {currentTime: event.target.getCurrentTime(), sessionId: sessionId}
            switch (event.data) {
                case YT.PlayerState.PLAYING:
                    lobbyChannel.push("play", payload)
                    break;
                case YT.PlayerState.PAUSED:
                    lobbyChannel.push("pause", payload)
                    break;
            }
        }

        function onChannelPlay(payload) {
            if (sessionId === payload.sessionId) return;

            player.playVideo();
            let diff = player.getCurrentTime() - payload.currentTime;
            if (diff >= 0.5 || diff <= -0.5)
                player.seekTo(payload.currentTime)
        }

        function onChannelPause(payload) {
            if (sessionId === payload.sessionId) return;

            let diff = player.getCurrentTime() - payload.currentTime;
            if (diff <= 1 || diff >= -1)
                player.pauseVideo();
        }
    }
}

export default Hooks;