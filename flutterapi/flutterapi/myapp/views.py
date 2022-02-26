from django.shortcuts import render
from django.http import JsonResponse

from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework import status
from .serializers import TodolistSerializer
from .models import Todolist

# GET Data
@api_view(['GET'])
def all_todolist(request):
    alltodolist = Todolist.objects.all() 
    #ดึงข้อมูลจาก model Todolist
    serializer = TodolistSerializer(alltodolist,many=True)
    return Response(serializer.data, status=status.HTTP_200_OK)

# POST Data ( save data to DB )
@api_view(['POST'])
def post_todolist(request):
    if request.method == 'POST':
        serializer = TodolistSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data,status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_404_NOT_FOUND)
        
    
@api_view(['PUT'])
def update_todolist(request,TID):
    # .../api/update-todolist/13   .... 13 = id
    todo = Todolist.objects.get(id=TID)
    if request.method == 'PUT':
        data = {}
        serializer = TodolistSerializer(todo,data=request.data)
        if serializer.is_valid():
            serializer.save()
            data['status'] = 'updated'
            return Response(data=data,status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_404_NOT_FOUND)
    
@api_view(['DELETE'])
def delete_todolist(request,TID):
    todo = Todolist.objects.get(id=TID)

    if request.method == 'DELETE':
        delete = todo.delete()
        data = {}
        if delete:
            data['status'] = 'deleted'
            statuscode = status.HTTP_200_OK
        else:
            data['status'] = 'failed'
            statuscode = status.HTTP_400_BAD_REQUEST  #ดูจาก STATUS CODE Django rest framework
        return  Response(data=data, status=statuscode)
        

data = [
    {
        "title":"ขนมจีน",
        "subtitle":"อาหารจีน",
        "image_url":"https://raw.githubusercontent.com/TJessada/BasicAPI/main/noodle-2402592_960_720.png",
        "detail":"จจจจจจจจจจจจจจจจจจจจจจจจจจ\n\nปปปปปปปปปปปปป"
    },
    {
        "title":"ขนมฝรั่ง",
        "subtitle":"อาหารฝรั่ง",
        "image_url":"https://raw.githubusercontent.com/TJessada/BasicAPI/main/eclair-3366430_960_720%20(1).jpg",
        "detail":"ฝฝฝฝฝฝฝฝฝฝฝฝฝฝฝฝฝฝฝ ฝฝฝฝ ฝฝฝฝฝฝฝฝฝฝฝฝฝฝ\n\nฝฝฝฝฝฝฝฝฝฝฝฝฝฝฝฝฝ"
    },

    {
        "title":"ขนมญี่ปุ่น",
        "subtitle":"อาหารญี่ปุ่น",
        "image_url":"https://raw.githubusercontent.com/TJessada/BasicAPI/main/japanese-sweets-6041180_960_720.jpg",
        "detail":"ญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญญ"
    }


]

def Home(request):
    return JsonResponse(data=data,safe=False, json_dumps_params={'ensure_ascii': False})