FROM python:3.6
EXPOSE 5000
COPY app.py .
RUN pip install flask
CMD ["python",  "./app.py"]

