import 'dart:async';
import 'package:meta/meta.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:geolocator/geolocator.dart' as Geolocator;

import 'package:bloc/bloc.dart';
part 'mi_ubicacion_event.dart';
part 'mi_ubicacion_state.dart';

class MiUbicacionBloc extends Bloc<MiUbicacionEvent, MiUbicacionState> {
  MiUbicacionBloc() : super(MiUbicacionState());

  StreamSubscription<Geolocator.Position> _positionSubscription;

  void iniciarSeguimiento(){
    
    this._positionSubscription = Geolocator.getPositionStream(
      desiredAccuracy: Geolocator.LocationAccuracy.high,
      distanceFilter: 10
    ).listen(( Geolocator.Position position ) {
      // print(position);
      final newLocation = new LatLng(position.latitude, position.longitude);
      add( OnUbicacionCambio(newLocation) );
    });
  }

  void cancelarSeguimiento(){
    this._positionSubscription?.cancel();
  }

  @override
  Stream<MiUbicacionState> mapEventToState(
    MiUbicacionEvent event,
  ) async* {
    
    // event => Posiciones Latlng

    if( event is OnUbicacionCambio ){
      // print( event );
      yield state.copyWith(
        existeUbicacion: true,
        ubicacion: event.ubicacion
      );
    }

  }
}
