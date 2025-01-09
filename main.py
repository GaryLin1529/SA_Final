import subprocess

def run_app():
    subprocess.run(["python", "manual-system/app.py"])

def run_test():
    subprocess.run(["python", "violation-system/test.py"])

def run_all():
    subprocess.run(["python", "app.py"])

if __name__ == "__main__":
    run_app()
    run_test()
