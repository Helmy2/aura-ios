import Shared


extension Wallpaper {
    public func copy(
        isFavorite: Bool? = nil
    ) -> Wallpaper {
        return Wallpaper(
            id: self.id,
            imageUrl: self.imageUrl,
            smallImageUrl: self.smallImageUrl,
            photographer: self.photographer,
            photographerUrl: self.photographerUrl,
            averageColor: self.averageColor,
            height: Int32(self.height),
            width: Int32(self.width),
            isFavorite: isFavorite ?? self.isFavorite,
            addedAt: addedAt
        )
    }
}
