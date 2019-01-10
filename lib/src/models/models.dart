enum ViewState { LOADING, SUCCESS, ERROR }

class Response<T> {
  ViewState state;
  T data;
  String errors;

  Response(this.state, this.data, this.errors);

  static Response<T> loading<T>() {
    return Response(ViewState.LOADING, null, null);
  }

  static Response<T> success<T>(T data) {
    return Response(ViewState.SUCCESS, data, null);
  }

  static Response<T> error<T>(String error) {
    return Response(ViewState.SUCCESS, null, error);
  }
}

class GithubUserResponse {
  int totalCount;
  bool incompleteResults;
  List<GithubUser> items = [];

  GithubUserResponse.fromJson(Map<String, dynamic> parsedJson) {
    totalCount = parsedJson['total_count'];
    incompleteResults = parsedJson['incomplete_results'];
    List<GithubUser> temp = [];
    for (int i = 0; i < parsedJson['items'].length; i++) {
      GithubUser githubUser = GithubUser.fromJson(parsedJson['items'][i]);
      temp.add(githubUser);
    }
    items = temp;
  }
}

class GithubUser {
  final String login,
      nodeId,
      avatarUrl,
      url,
      htmlUrl,
      followersUrl,
      followingUrl,
      gistsUrl,
      starredUrl,
      subscriptionsUrl,
      organizationsUrl,
      reposUrl,
      eventsUrl,
      receivedEventsUrl,
      type;
  final int id;
  final double score;

  GithubUser(
      {this.login,
      this.id,
      this.nodeId,
      this.avatarUrl,
      this.url,
      this.htmlUrl,
      this.followersUrl,
      this.followingUrl,
      this.gistsUrl,
      this.starredUrl,
      this.subscriptionsUrl,
      this.organizationsUrl,
      this.reposUrl,
      this.eventsUrl,
      this.receivedEventsUrl,
      this.type,
      this.score});

  factory GithubUser.fromJson(Map json) {
    return GithubUser(
        login: json['login'],
        id: json['id'],
        nodeId: json['node_id'],
        avatarUrl: json['avatar_url'],
        url: json['url'],
        htmlUrl: json['html_url'],
        followersUrl: json['followers_url'],
        followingUrl: json['following_url'],
        gistsUrl: json['gists_url'],
        starredUrl: json['starred_url'],
        subscriptionsUrl: json['subscriptions_url'],
        organizationsUrl: json['organizations_url'],
        reposUrl: json['repos_url'],
        eventsUrl: json['events_url'],
        receivedEventsUrl: json['received_events_url'],
        type: json['type'],
        score: json['score']);
  }
}
