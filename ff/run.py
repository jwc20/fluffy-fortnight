"""
For debugging
"""
from ff import create_app

app = create_app()

def main():
    print("welcome to ff!")

if __name__ == "__main__":
    main()
    port = app.config.get('PORT', 8412)
    app.run(host='localhost', port=port, debug=True)
