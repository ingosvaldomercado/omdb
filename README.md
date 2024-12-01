# OMDB iOS Demo
##### _Implementing Swift, SwiftUI, Core Data_

[![Top Langs](https://github-readme-stats.vercel.app/api/top-langs/?username=ingosvaldomercado&layout=compact)](https://github.com/ingovaldomercado)

This is a demo for OMDB API in iOS with SwiftUI.

## Specifications
This demo was writen in Swift and SwiftUI, the API requests are performing throught URLSession and the concurrency was implemented with async/await Framework. There is also a persistance layer with Core Data to save locally the favorite movies. This means that there is no any third-party library implemented in this project and there isn't any package dependency implemented.

## Requirements

- Git
- XCode 15.0^

## Instalation

First, clone the project from GitHub with:

```sh
git clone git@github.com:ingosvaldomercado/omdb.git
cd omdb
open .
```

Open the `omdb.xcodeproj` file inside the project's folder. This should open XCode. Verifiy you have a simulator selected.

Once XCode does index of the project you can build with command+B or go to Product option from the top menu and then Build. This process should compile the project and run the simulator.

## Architecture

This app was written in Swift 5, and the UI was shaped with SwiftUI.

There are four main folders:

- Config
- Data 
- Networking
- UI

### Config

Sensible data as API token and API URLs are inside a xcconfig file. For this demo, there is a `secrets.xcconfig` file with some keys and token. This was added just for this demo, however the best approach is to have those keys into de env, or keep this file safely. Working with env you can use it locally as CD/CI pipelines.

Those values are being fetched by the ConfigManager, that it's a singleton to work as interface to get the values through any place into the app.

##### Keys and tokens

|Key|Description|
|-----|----|
|I_KEY|i Key provided by OMDB API|
|API_KEY|API KEY provided by OMDB API|
|DEV_API_BASE_URL|Base URL for the API|
|PROD_API_BASE_URL|Base URL for the API|

For this demo the Dev and Prod base URL are the same. But in real scenarios it's a good approach to keep those environments separatelly; and depending on the schema we are building it should fetch the expected base URL. 

### Data

This is the container of the Entities, Models and struct of the API responses, conforming from Codable protocol to be decoded by the Networking Layer.

It also has interface for Persistance with Core Data.

##### Codables

- Movie:

|Property|Type|Description|
|-----|----|----|
|title|String|Name of the movie|
|year|String|Release year|
|poster|Optional String|URL of the movie poster|
|type|Type enum|Different types of format|
|imbdId|String|ID of the movie in iMDB|

##### Core Data Entities

- FavoriteMovie

|Property|Type|Description|
|-----|----|----|
|id|UUID|Unique value or primary key|
|title|String|Name of the movie|
|year|String|Release year|
|imbdId|String|ID of the movie in iMDB. This field is used for queries|

### Networking

Here is the struct and classes to allow us to perform RestFul API calls. This offers some protocols where we can build the necesary to create Endpoints and requests.

It handles the concurrency with async/await, and also, it verifies and handles the errors coming from server, wrong api responses, wrong parsing.

In a successful response, it returns the expected Model Response.

### UI

Finally, the contains the view grouped by functionality. Per each functionality, we have the View itself, developed with SwiftUI and his ViewModel that in most of cases are ObserverdObject classes.

Implementing MVVM we ensure a decopled code, and allows us to keep an organized code, write clear unit testing by mocking, follow SOLID concepts.   

### TO-DO

- Keep more description and imbd rate from API. The API calls are not returning this info even if we add the plot full parameter in the request URL.
- Fix pagination. There is a known issue when we fetch the latest page from the API. (WIP)
- Add unit testing.

## License

MIT
