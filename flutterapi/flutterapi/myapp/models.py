from django.db import models

class Todolist(models.Model):
    title = models.CharField(max_length=100) # ไม่ได้ใส่เหมือนบรรทัดล่าง แสดงว่าบังคับใส่ field นี้
    detail = models.TextField(null=True, blank=True) # ใส่ null=true , blank=true แสดงว่าไม่บังคับใส่

    def __str__(self): #เพิ่มหัวข้อในหน้า admin จะได้อ่านง่าย
        return self.title #ถ้าเปลี่ยนข้อมูล file นี้ save แล้ว ให้ makemigrations และ migrate อีกครั้ง

