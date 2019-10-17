import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './models/movieDetailModel.dart';
import './models/movieModel.dart';
import 'package:intl/intl.dart';
import 'models/tmdb.dart';




const baseUrl = "https://api.themoviedb.org/3/movie/";
const baseImagesUrl = "https://image.tmdb.org/t/p/";
const apiKey = Tmdb.apikey;
const lenguage = "&language=es-ES";

class MovieDetail extends StatefulWidget{
  final Results movie;

  MovieDetail({this.movie});

  @override
  _MovieDetails createState() => new _MovieDetails();
}

class _MovieDetails extends State<MovieDetail>{
  String movieDetailUrl;
  MovieDetailModel movieDetails;
  String result;

  @override
  void initState() {
    super.initState();
    movieDetailUrl = '$baseUrl${widget.movie.id}?api_key=$apiKey$lenguage';
    _fechMovieDetails();
  }

  void _fechMovieDetails() async{
    var response = await http.get(movieDetailUrl);
    var decodeJson = jsonDecode(response.body);
    setState(() {
     movieDetails = MovieDetailModel.fromJson(decodeJson); 
    });
  }

  String _getMovieDuration (int runtime){
    if(runtime == null) return "No Data";
    double movieHours = runtime / 60;
    int movieMinutes = ((movieHours - movieHours.floor())*60).round();
    return '${movieHours.floor()}h ${movieMinutes}mm';
    

  }

  @override
  Widget build(BuildContext context) {

    final moviePoster = Container(
      height: 350.0,
      padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Center(
        child: Card(
          elevation: 15.0,
          child: Hero(
            tag: widget.movie.heroTag,
            child: Image.network("${baseImagesUrl}w342${widget.movie.posterPath}", 
            fit: BoxFit.cover,
            ),
          ))));

    final movieTitle = Padding(
        padding: const EdgeInsets.only(top:4.0, bottom: 8.0),
          child: Center(
            child: Text(
              widget.movie.title,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
        ),
      ),
    );

    final movieTikets = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(movieDetails != null ? _getMovieDuration(movieDetails.runtime): "",
          style: TextStyle(fontSize: 11.0),
        ),
        Container(
          height: 20.0,
          width: 1.0,
          color: Colors.white70,
        ),
        Text("relese Data: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.movie.releaseDate))}",
        style: TextStyle(fontSize: 11.0),
        ),
        RaisedButton(
           shape: StadiumBorder(),
           elevation: 15.0,
           color: Colors.red[700],
           child: Text('tickets'),
           onPressed: (){

           },
        )
      ],
    );

    final genresList = Container(
      height: 25.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: ListView(
            scrollDirection: Axis.horizontal,
            children: movieDetails == null ? [] : movieDetails.genres.map((g) => Padding(
              padding: const EdgeInsets.only(right: 6.0),
              child: FilterChip(
              backgroundColor: Colors.green[600],
              labelStyle: TextStyle(fontSize: 10.0),
              label: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(g.name),
              ),
              onSelected: (b){},
              ),
          )).toList(),
            
          ),
      ));

    final middleContect = Container(
      padding: EdgeInsets.only(left: 8.0, right: 8.0 , top: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Divider(),
          genresList,
          Divider(),
          Text('SYNOPSIS',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[300]),            
          ),
          SizedBox( height: 9.0,),
          
          Text(widget.movie.overview,
            style: TextStyle(color: Colors.green[300], fontSize: 11.0),
          ),
          
          
          SizedBox( height: 10.0,
          ),
        ],
      ),
    );
     

    




    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text("Movie App", style: TextStyle(color: Colors.white, fontSize: 14.0 , fontWeight: FontWeight.bold),),
      ),
      body: ListView(
        children: <Widget>[
          moviePoster,
          movieTitle,
          movieTikets,
          middleContect,
          
        ],
      ),
    );
    
  }
  
}

