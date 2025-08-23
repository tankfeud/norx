# Pong by Claude Code

This sample was made by Claude Code and then a few small adjustments. The prompts were:

1. "Can you create a new example that is a the classic ping pong game from very old consoles (just two 
  vertical bars and a bouncing ball between them) where one player can control their vertical bar using w 
  and s key and the right side player use cursor up and down?"

● I'll create a classic Pong game using the Norx wrapper. Let me break this down into manageable tasks.

● Update Todos

  ⎿  ☐ Examine existing sample structure to understand project conventions 
     ☐ Create pong.nim example with basic game setup and ORX initialization
     ☐ Implement paddle objects (left and right vertical bars)
     ☐ Implement ball object with physics and bouncing
     ☐ Add keyboard input handling for W/S (left paddle) and Up/Down (right paddle)
     ☐ Test the game to ensure it works correctly

Claude then made this plan:

## Pong Game Implementation Plan

    Based on my analysis of the Norx codebase, I'll create a classic Pong game following these conventions:

    Structure

    - Location: Create pong.nim in a new directory samples/pong/
    - Configuration: Use .ini file for game setup (graphics, input, physics)
    - Data: Include necessary texture files for paddles and ball

    Implementation Plan

    1. Project Setup

    - Create samples/pong/ directory structure
    - Create pong.nim main game file
    - Create pong.nimble package file
    - Set up data/ directory with config and textures

    2. Core Game Components

    - Main Loop: Use standard ORX init/run/exit pattern with execute()
    - Viewport & Camera: Standard game viewport setup
    - Input System: Configure W/S for left paddle, UP/DOWN for right paddle

    3. Game Objects

    - Left Paddle: Vertical bar controlled by W/S keys
    - Right Paddle: Vertical bar controlled by UP/DOWN arrow keys  
    - Ball: Moving object with physics-based bouncing
    - Boundaries: Top/bottom walls for ball collision

    4. Game Logic

    - Paddle Movement: Real-time input handling to move paddles up/down
    - Ball Physics: Continuous movement with collision detection
    - Collision System: Ball bounces off paddles and walls
    - Score Tracking: Basic scoring when ball exits sides

    5. Technical Implementation

    - Use ORX's physics system for collision detection
    - Configure input bindings in .ini file 
    - Use object hierarchies for game components
    - Implement update loop using clock callbacks

    6. Files to Create

    - samples/pong/pong.nim - Main game logic
    - samples/pong/pong.nimble - Package configuration
    - samples/pong/data/config/pong.ini - Game configuration
    - samples/pong/data/texture/ - Simple paddle/ball graphics

    The implementation will follow Norx conventions using {.cdecl.} pragmas, isActive() for input, and ORX's
     object/physics systems.

2. The first result was almost there, but the textures reused were square and sizes were off. And physics was a bit crazy with paddles drifting etc.

   "The paddles are too small and the ball is too large. Also the paddles bounce away when hit."


After this Claude Code got a bit confused after I told it to try to use texture "pixel" and then I ran out of tokens so I made some small adjustments:
- Fixing ini file a bit, fixed rotation, density and Claude had accidentally removed some body references and also removed the top and bottom walls it had created in the beginning.
- Adding two lines in pong.nim creating topWall and bottomWall. **But all the rest of the code is as generated**

