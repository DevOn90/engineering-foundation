import { Component, inject, OnInit } from '@angular/core';
import { RouterLink } from "@angular/router";
import { ApiService } from '../../../../core/services/api';
import { CommonModule } from '@angular/common';

interface User {
  id:number,
  name:string
}
@Component({
  selector: 'app-user-list-page',
  imports: [
    RouterLink,
    CommonModule
  ],
  templateUrl: './user-list-page.html',
  styleUrl: './user-list-page.scss',
})
export class UserListPage implements OnInit {

  private api = inject(ApiService);
  public users: User[] = [];


  ngOnInit(): void {
    this.api
    .get<User[]>('/api/v1/users')
    .subscribe(res => {
      this.users = res
    })
  }
}
