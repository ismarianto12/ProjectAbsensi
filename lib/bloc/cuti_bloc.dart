import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:penjualan/service/HttpService.dart';

@immutable
abstract class CutiEvent extends Equatable {
  const CutiEvent();
  @override
  List<Object> get props => [];
}

final class CutiEventSubmit extends CutiEvent {
  final Map<String, Object> data;
  CutiEventSubmit({required this.data});
}

final class CutiEventgetData extends CutiEvent {
  @override
  List<Object> get props => [];
}

final class CutiEventLoaded extends CutiEvent {
  @override
  List<Object> get props => [];
}

abstract class CutiState extends Equatable {
  const CutiState();
  @override
  List<Object> get props => [];
}

final class CutiIntial extends CutiState {
  CutiIntial();
  @override
  List<Object> get props => [];
}

final class CutistateSucces extends CutiState {
  final String message;
  CutistateSucces({required this.message});

  @override
  List<Object> get props => [message];
}

  class CutistateFail extends CutiState {
  String message;
  CutistateFail({required this.message});
  @override
  List<Object> get props => [this.message];
}

final class CutiBloc extends Bloc<CutiEvent, CutiState> {
  CutiBloc() : super(CutiIntial()) {
    on<CutiEventSubmit>((event, emit) async {
      String bearer = "";

      final data = event.data;

      final nama = data['nama'] as String;
      final tujuan = data['tujuan'] as String;
      final tanggalMulai = data['tanggalMulai'] as String;
      final tanggalAkhir = data['tanggalAkhir'] as String;

      dynamic response =
          HttpService.post('savecuti', {"Authorization": bearer}, {data: data});
      print(response);
      if (response.statusCode == 200) {}
      emit(CutistateSucces(message: "success update data"));
    });
  }
}
