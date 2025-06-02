part of 'favorites_cubit.dart';

abstract class FavoritesState extends Equatable {
  final List<Favorite>? favorites;
  final List? reportCubits;
  final FavoritesSequenceEntity? sequence;
  const FavoritesState({this.favorites,this.reportCubits,this.sequence});

  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Favorite>? favoritesList;
  final List? reportCubitList;
  final FavoritesSequenceEntity? sequenceList;
  FavouriteSuccess? success;
  FavouriteError? error;
  FavoriteNameLoading? nameLoading;
  FavoritesLoaded({
    required this.favoritesList,
    required this.reportCubitList,
    required this.sequenceList,
    this.success,
    this.error,
    this.nameLoading,
  }) :super(favorites: favoritesList,reportCubits: reportCubitList,sequence: sequenceList);

  @override
  List<Object> get props => [];
}

class FavoritesError extends FavoritesState {
  final AppErrorType errorType;

  const FavoritesError({
    required this.errorType,
  });
}

class FavoritesLoading extends FavoritesState {}

class FavoriteNameLoading extends FavoritesState {
  final int? id;
  const FavoriteNameLoading({this.id});
}

class FavouriteSuccess {
  final bool? create;
  final bool? update;
  final bool? delete;
  final bool? nameChange;
  final bool? pinUnpin;
  final bool? sequence;
  const FavouriteSuccess({this.create, this.delete, this.update,this.nameChange,this.pinUnpin,this.sequence}): assert(create!=null || update!=null || delete!=null || nameChange!=null || pinUnpin!=null || sequence!=null,"only one needed");

  String get message {
    if(sequence ?? false){
      return "Successfully updated sequence";
    }
    return "Successfully ${(create ?? false)?'added to':(update ?? false)?'updated':(delete ?? false)?'deleted':(nameChange ?? false)?'changed name of':(pinUnpin ?? false)?"pinned":"unpinned"} favorite";  }
}

class FavouriteError {
  final bool? create;
  final bool? update;
  final bool? delete;
  final bool? nameChange;
  final bool? pinUnpin;
  final bool? sequence;
  final bool? limitReached;
  const FavouriteError({this.create, this.delete, this.update,this.nameChange,this.pinUnpin,this.sequence,this.limitReached}): assert(create!=null || update!=null || delete!=null || nameChange!=null || pinUnpin!=null || sequence!=null || limitReached!=null,"only one needed");

  String get message {
    if(sequence ?? false){
      return "Failed to update sequence";
    }else if(limitReached ?? false){
      return "Limit reached of 20 favorites";
    }else if(create ?? false){
      return "Failed to create favorite";
    }else if(update ?? false){
      return "Failed to update favorite";
    }else if(delete ?? false){
      return "Failed to delete favorite";
    }else if(nameChange ?? false){
      return "Failed to change name";
    }
    return "Successfully ${(create ?? false)?'added to ':(update ?? false)?'updated':(delete ?? false)?'deleted':(nameChange ?? false)?'changed name of':(pinUnpin ?? false)?"pinned":"unpinned"} favorite";

  }
}