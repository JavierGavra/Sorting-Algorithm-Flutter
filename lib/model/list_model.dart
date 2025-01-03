enum ListItemStatus { normal, selected, selected2, correctPosition }

class ListItemModel {
  int number;
  ListItemStatus status;

  ListItemModel(this.number, {this.status = ListItemStatus.normal});
}