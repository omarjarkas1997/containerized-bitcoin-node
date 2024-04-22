#!/usr/bin/env python3
import json
import hmac
from secrets import token_hex, token_urlsafe
from argparse import ArgumentParser
from getpass import getpass

def generate_salt(size):
    """Create size byte hex salt"""
    return token_hex(size)

def generate_password():
    """Create 32 byte b64 password"""
    return token_urlsafe(32)

def password_to_hmac(salt, password):
    """Convert password using HMAC SHA256 and the provided salt"""
    m = hmac.new(salt.encode('utf-8'), password.encode('utf-8'), 'SHA256')
    return m.hexdigest()

def main():
    parser = ArgumentParser(description='Create login credentials for a JSON-RPC user')
    parser.add_argument('username', help='the username for authentication')
    parser.add_argument('password', help='leave empty to generate a random password or specify "-" to prompt for password', nargs='?')
    args = parser.parse_args()

    if not args.password:
        args.password = generate_password()
    elif args.password == '-':
        args.password = getpass()

    salt = generate_salt(16)
    password_hmac = password_to_hmac(salt, args.password)

    # Create a dictionary containing the results
    result = {
        "rpcauth": f"{args.username}:{salt}${password_hmac}",
        "password": args.password
    }

    # Print the results as a JSON string
    print(json.dumps(result))

if __name__ == '__main__':
    main()
