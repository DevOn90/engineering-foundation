import { HttpClient } from "@angular/common/http";
import { Injectable } from "@angular/core";
import { AppConfig } from "./app-config";
import { firstValueFrom } from "rxjs";

@Injectable({ providedIn: 'root' })
export class ConfigService {

    private config!: AppConfig;

    constructor(private http: HttpClient) {}

    load(): Promise<void> {

        return firstValueFrom(
            this.http.get<AppConfig>('assets/config.json')
        ).then(config => {
            this.config = config
        }).catch(err => {
            console.error("Failed to load config.json",err);
            throw err
        })
    }

    get apiBaseUrl(): string {
        return this.config.apiBaseUrl;
    }

    get env(): string {
        return this.config.env;
    }

    get debug(): boolean {
        return this.config.debug;
    }
}