import Foundation

struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL
    
//    var betterQualityImageURL: URL {
//        URL(string: rating.components(separatedBy: "._")[0] + "._V0_UX600_.jpg") ?? imageURL
//    }
    
    private enum CodingKeys: String, CodingKey {
    case title = "fullTitle"
    case rating = "imDbRating"
    case imageURL = "image"
    }
}

//[
//    "id":"tt0111161",
//    "rank":"1",
//    "title":"The Shawshank Redemption",
//    "fullTitle":"The Shawshank Redemption (1994)",
//    "year":"1994",
//    "image":"https://m.media-amazon.com/images/M/MV5BMDAyY2FhYjctNDc5OS00MDNlLThiMGUtY2UxYWVkNGY2ZjljXkEyXkFqcGc@._V1_.jpg",
//    "crew":"",
//    "imDbRating":"9.3",
//    "imDbRatingCount":"3006130"
//]
