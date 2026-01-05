import Shared

extension Video {
    func copy(
        isFavorite: Bool
    ) -> Video {
        return Video(
            id: self.id,
            width: self.width,
            height: self.height,
            url: self.url,
            image: self.image,
            duration: self.duration,
            user: self.user,
            videoFiles: self.videoFiles,
            videoPictures: self.videoPictures,
            isFavorite: isFavorite,
            addedAt: self.addedAt
        )
    }
}
