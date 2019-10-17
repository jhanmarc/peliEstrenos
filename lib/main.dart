import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './models/movieModel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'models/tmdb.dart';
import 'movieDetails.dart';

const baseUrl = "https://api.themoviedb.org/3/movie/";
const baseImagesUrl = "https://image.tmdb.org/t/p/";
const apiKey = Tmdb.apikey;
const lenguage = "&language=es-ES";

const nowPlayingUrl = "${baseUrl}now_playing?api_key=$apiKey$lenguage";
const upcomingUrl = "${baseUrl}upcoming?api_key=$apiKey$lenguage";
const popularUrl = "${baseUrl}popular?api_key=$apiKey$lenguage";
const topRatedUrl = "${baseUrl}top_rated?api_key=$apiKey$lenguage";

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: ThemeData.dark(),
      home: MyMovieApp(),
      
));

class MyMovieApp extends StatefulWidget {
  @override
  _MyMovieApp createState() => _MyMovieApp();
}

class _MyMovieApp extends State<MyMovieApp> {
  Movie nowPlayinMovies;
  Movie upcomingMovies;
  Movie popularMovies;
  Movie topRatedMovies;
  int heroTag = 0;
  int _currentIndex = 0;

  void initState() {
    super.initState();
    
    _fetchNowPlayingMovies();
    _fetchUpComingMovies();
    _fetchPopularMovies();
    _fetchTopRateMovies();
    
  }

  void _fetchNowPlayingMovies() async {
    var response = await http.get(nowPlayingUrl);
    var decodeJson = jsonDecode(response.body);
    setState(() {
      nowPlayinMovies = Movie.fromJson(decodeJson);
    });
    
  }

  void _fetchUpComingMovies() async {
    var response = await http.get(upcomingUrl);
    var decodeJson = jsonDecode(response.body);
    setState(() {
      upcomingMovies = Movie.fromJson(decodeJson);
    });
  }

  void _fetchPopularMovies() async {
    var response = await http.get(popularUrl);
    var decodeJson = jsonDecode(response.body);
    setState(() {
      popularMovies = Movie.fromJson(decodeJson);
    });
    
  }

  void _fetchTopRateMovies() async {
    var response = await http.get(topRatedUrl);
    var decodeJson = jsonDecode(response.body);
    setState(() {
      topRatedMovies = Movie.fromJson(decodeJson);
    });
  }

  Widget _buildCarouselSlider() => CarouselSlider(
        items: nowPlayinMovies == null
            ? <Widget>[Center(child: CircularProgressIndicator())]
            : nowPlayinMovies.results
                .map((movieItem) => _buildMovieItem(movieItem))
                .toList(),
        autoPlay: false,
        height: 240.0,
        viewportFraction: 0.5,
        
  );

  Widget _buildMovieItem(Results movieItem) {
    heroTag += 1;
    movieItem.heroTag = heroTag;

    return Material(
      elevation: 15.0,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (contex) => MovieDetail(movie: movieItem)));
        },
        child: Hero(
          tag: heroTag,
          child: Image.network("${baseImagesUrl}w342${movieItem.posterPath}",
              fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _builMovieListItem(Results movieItem) => Material(
        child: Container(
          width: 128.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(6.0),
                  child: _buildMovieItem(movieItem)),
              Padding(
                padding: EdgeInsets.only(left: 6.0, top: 2.0),
                child: Text(
                  movieItem.title,
                  style: TextStyle(fontSize: 8.0),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 6.0, top: 2.0),
                child: Text(
                  DateFormat('yyyy')
                      .format(DateTime.parse(movieItem.releaseDate)),
                  style: TextStyle(fontSize: 8.0),
                ),
              ),
            ],
          ),
        ),
    
    );

  Widget _builMoviesListView(Movie movie, String movieListTitle) => Container(
        height: 258.0,
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 7.0, bottom: 7.0),
                child: Text(movieListTitle,
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400]))),
            Flexible(
                child: ListView(
              scrollDirection: Axis.horizontal,
              children: movie == null
                  ? <Widget>[Center(child: CircularProgressIndicator())]
                  : movie.results
                      .map((movieItem) => Padding(
                            padding: EdgeInsets.only(left: 6.0, right: 2.0),
                            child: _builMovieListItem(movieItem),
                          ))
                      .toList(),
            ))
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Movie App",
          style: TextStyle(
              color: Colors.white, //color del texto
              fontSize: 14.0, //tamaño de fuente
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        /*leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
           
          },
        ),*/
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {

            },
          )
        ],
        
      ),
      
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      "PELICULAS NUEVAS",
                      style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                expandedHeight: 290.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: <Widget>[
                      
                      Container(
                        child: Image.network(
                          "https://www.eltiempo.com/files/article_main/uploads/2018/11/26/5bfc720e589e0.jpeg",
                          //"${baseImagesUrl}w500/or06FN3Dka5tukK1e9sl16pB3iy.jpg",
                          fit: BoxFit.cover,
                          width: 1000.0,
                          colorBlendMode: BlendMode.dstATop,
                          color: Colors.blue.withOpacity(0.5),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 35.0),
                          child: _buildCarouselSlider())
                    ],
                  ),
                ),
              )
            ];
          },
          body: ListView(
            children: <Widget>[
              _builMoviesListView(popularMovies, 'POPULAR'),
              _builMoviesListView(upcomingMovies, 'COMING SOON'),
              _builMoviesListView(topRatedMovies, 'TOP RATED'),
            ],
          )),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.lightBlue,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() => _currentIndex = index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_movies),
            title: Text('Peliculas'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.tag_faces), title: Text('Tikets')),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text('Usuario')),
        ],
      ),
    );
  }
}
