class ApiUrls {
  static String fetchDataURL(int count,int page)=>
     "https://jsonplaceholder.typicode.com/posts?_page=$page&_limit=$count";
}