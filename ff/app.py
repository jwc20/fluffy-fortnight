"""
For debugging
"""
from ff import create_app

app = create_app()

def main():
    print("welcome to ff!")

if __name__ == "__main__":
    main()
    app.run(debug=True)
