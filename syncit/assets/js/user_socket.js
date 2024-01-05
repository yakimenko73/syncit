import {Socket} from "phoenix"

let socket = new Socket("/socket")
socket.connect()

let channel = socket.channel("lobby", {})
channel.join()
    .receive("ok", resp => {
        console.log("Joined successfully", resp)
    })
    .receive("error", resp => {
        console.log("Unable to join", resp)
    })
channel.on("play", payload => {
    let timingDiff = player.getCurrentTime() - payload.currentTime;
    player.playVideo();
    if (timingDiff >= 2.0 || timingDiff <= -2.0) {
        console.debug("seekTo")
        player.seekTo(payload.currentTime)
    }
})
channel.on("pause", () => {
    player.pauseVideo()
})

window.roomChannel = channel

export default socket
