import jwt from 'jsonwebtoken';

/**
 * JWT Utility Functions
 *
 * Handles JSON Web Token generation and verification
 * for user authentication and authorization.
 */

const JWT_SECRET = process.env.JWT_SECRET;
const JWT_EXPIRES_IN = process.env.JWT_EXPIRES_IN || '7d';

if (!JWT_SECRET) {
  throw new Error('JWT_SECRET is not defined in environment variables');
}

/**
 * Generate a JWT token for a user
 *
 * @param {string} userId - The user's unique identifier
 * @returns {string} - Signed JWT token
 */
export const generateToken = (userId) => {
  try {
    const token = jwt.sign(
      {
        userId,
        iat: Math.floor(Date.now() / 1000), // Issued at time
      },
      JWT_SECRET,
      {
        expiresIn: JWT_EXPIRES_IN,
      }
    );

    return token;
  } catch (error) {
    console.error('Error generating token:', error);
    throw new Error('Failed to generate authentication token');
  }
};

/**
 * Verify and decode a JWT token
 *
 * @param {string} token - The JWT token to verify
 * @returns {object} - Decoded token payload containing userId
 * @throws {Error} - If token is invalid or expired
 */
export const verifyToken = (token) => {
  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    return decoded;
  } catch (error) {
    if (error.name === 'TokenExpiredError') {
      throw new Error('Token has expired');
    } else if (error.name === 'JsonWebTokenError') {
      throw new Error('Invalid token');
    } else {
      throw new Error('Token verification failed');
    }
  }
};

/**
 * Generate a password reset token
 *
 * @param {string} userId - The user's unique identifier
 * @returns {string} - Signed JWT token with short expiration
 */
export const generateResetToken = (userId) => {
  try {
    const token = jwt.sign(
      {
        userId,
        type: 'password_reset',
        iat: Math.floor(Date.now() / 1000),
      },
      JWT_SECRET,
      {
        expiresIn: '1h', // Reset tokens expire in 1 hour
      }
    );

    return token;
  } catch (error) {
    console.error('Error generating reset token:', error);
    throw new Error('Failed to generate reset token');
  }
};

/**
 * Verify a password reset token
 *
 * @param {string} token - The reset token to verify
 * @returns {object} - Decoded token payload
 * @throws {Error} - If token is invalid, expired, or not a reset token
 */
export const verifyResetToken = (token) => {
  try {
    const decoded = jwt.verify(token, JWT_SECRET);

    if (decoded.type !== 'password_reset') {
      throw new Error('Invalid token type');
    }

    return decoded;
  } catch (error) {
    if (error.name === 'TokenExpiredError') {
      throw new Error('Reset token has expired');
    } else if (error.name === 'JsonWebTokenError') {
      throw new Error('Invalid reset token');
    } else {
      throw new Error('Reset token verification failed');
    }
  }
};
