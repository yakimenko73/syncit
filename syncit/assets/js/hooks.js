let Hooks = {}
Hooks.Player = {
    videoId() {
        return this.el.getAttribute("video-id");
    },
    mounted() {
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

        function onPlayerReady(event) {
            event.target.playVideo();
        }

        function onPlayerStateChange(event) {
            switch (event.data) {
                case YT.PlayerState.PLAYING:
                    roomChannel.push("play", {currentTime: event.target.getCurrentTime()})
                    break;
                case YT.PlayerState.PAUSED:
                    roomChannel.push("pause", {currentTime: event.target.getCurrentTime()})
                    break;
                case YT.PlayerState.ENDED:
                    console.log('Video has ended');
                    break;
            }
        }
    }
}

export default Hooks;