
import { Controller, Post, Body, ParseIntPipe } from '@nestjs/common';

@Controller('users')
export class UsersController {
    @Post()
    create(@Body('id', ParseIntPipe) id: number) {
        console.log(typeof id); 
        return { id };
    }
}