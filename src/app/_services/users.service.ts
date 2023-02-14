import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { User } from '../_models/User';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { environment } from 'src/environments/environment';

@Injectable({
  providedIn: 'root'
})
export class UsersService {

  url = `${environment.HOST}` + 'user';

  constructor(private http: HttpClient) { }

  getUserList(): Observable<User[]> {
    return this.http.get<User[]>(this.url);
  }
  postUserData(userData: User): Observable<User> {
    const httpHeaders = { headers:new HttpHeaders({'Content-Type': 'application/json'}) };
    return this.http.post<User>(this.url, userData, httpHeaders);
  }
  updateUser(user: User): Observable<User> {
    const httpHeaders = { headers:new HttpHeaders({'Content-Type': 'application/json'}) };
    return this.http.put<User>(this.url, user, httpHeaders);
  }
  deleteUserById(id: number): Observable<number> {
    return this.http.delete<number>(this.url + '/' + id);
  }
  getUserDetailsById(id: string): Observable<User> {
    return this.http.get<User>(this.url + '/' + id);
  }
}
