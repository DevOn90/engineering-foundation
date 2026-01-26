import { HttpClient } from '@angular/common/http';
import { inject, Injectable } from '@angular/core';
import { ConfigService } from '../config/config.service';


@Injectable({
  providedIn: 'root',
})
export class ApiService {
  
  private http = inject(HttpClient);
  private config = inject(ConfigService);

  get<T>(path: string){
    return this.http.get<T>(`${this.config.apiBaseUrl}${path}`);
  }
}
