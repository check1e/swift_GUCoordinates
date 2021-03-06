/*
 * RelativeCoordinate.swift 
 * Coordinates 
 *
 * Created by Callum McColl on 09/07/2020.
 * Copyright © 2020 Callum McColl. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above
 *    copyright notice, this list of conditions and the following
 *    disclaimer in the documentation and/or other materials
 *    provided with the distribution.
 *
 * 3. All advertising materials mentioning features or use of this
 *    software must display the following acknowledgement:
 *
 *        This product includes software developed by Callum McColl.
 *
 * 4. Neither the name of the author nor the names of contributors
 *    may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
 * OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * -----------------------------------------------------------------------
 * This program is free software; you can redistribute it and/or
 * modify it under the above terms or under the terms of the GNU
 * General Public License as published by the Free Software Foundation;
 * either version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see http://www.gnu.org/licenses/
 * or write to the Free Software Foundation, Inc., 51 Franklin Street,
 * Fifth Floor, Boston, MA  02110-1301, USA.
 *
 */

import CGUCoordinates
import GUUnits

/// A `RelativeCoordinate` represents a coordinate that is relative to some
/// other coordinate.
///
/// This coordinate describes the distance and direction that one coordinate
/// is from another. We categorise these two coordinates as the source and
/// the target. The target is where the `RelativeCoordinate` is pointing
/// towards and the source is where the `RelativeCoordinate` is pointing from.
/// `RelativeCoordiante` is a polar coordinate in the form of phi, r where phi
/// is the direction and r is the distance to the coordinate.
///
/// The direction is an angle in degrees. A positive value for direction
/// indicates that the target is on the left. A negative value indicates that
/// the target is on the right. A value of zero indicates that the target is
/// directly in front of source.
///
/// The relative coordinate system can be viewed graphically as follows:
/// ```text
///                                       0 degrees
///                                                 * (-10 degrees, 40 cm)
///                           \               |               /
///                            \              |              /
///                             \             |             /
///                              \     ||| ///|/// |||     /
///                               \|//        |        //|/
///                            |// \          |          / //|
///                         |//     \         |         /     //|
///                       |//        \   / ///|/// /   /        //|
///                     |//          |\/      |      //|          //|
///                    |//        |//  \      |      /  //|        //|
///                   |//       |//     \     |     /     //|       //|
///                  |//      |//        \    |    /        //|      //|
///                 |//      |//          \/ -|- //          //|      //|
///                 //|     ,//         /- \  |  / -/         //,     |//
///                `//`     |//        |-   \ | /   -|        //|     `//`
///                |//      |//        -     \|/     -        //|      //|
///  90 degrees    |/-      |//       |-      V      -|       //|      -/|    -90 degrees
///                |//      |//        -    (0,0)    -        //|      //|
///                ,//,     |//        |-           -|        //|     ,//,
///                 //|     `//         /-         -/         //`     |//
///                 |//      |//           / - - /           //|      //|
///                  |//      |//                           //|      //|
///                   |//       |//                       //|       //|
///                    |//        |//                   //|        //|
///                     |//          |//             //|          //|
///                       |//            / /// /// /            //|
///                         |//                               //|
///                            |//                         //|
///                                |//                 //|
///                                    ||| /// /// |||
///
///
///                                    +/- 180 degrees
/// ```
public struct RelativeCoordinate: CTypeWrapper {

// MARK: Properties
    
    /// The heading towards the target.
    ///
    /// A positive value for direction indicates that the target is on
    /// the left. A negative value indicates that the target is on the
    /// right. A value of zero indicates that the target is pointing
    /// straight ahead.
    public var direction: Angle

    /// The distance to the target.
    public var distance: Distance

// MARK: Converting to/from the Underlying C Type
    
    /// Represent this coordinate using the underlying C type
    /// `gu_relative_coordinate`.
    public var rawValue: gu_relative_coordinate {
        return gu_relative_coordinate(
            direction: self.direction.degrees_d.rawValue,
            distance: self.distance.millimetres_u.rawValue
        )
    }
    
    /// Create a new `RelativeCoordinate` by copying the values from the
    /// underlying c type `gu_relative_coordinate`.
    ///
    /// - Parameter other: An instance of `gu_relative_coordinate` which contains
    /// the values that will be copied.
    public init(_ other: gu_relative_coordinate) {
        self.init(
            direction: Angle(Degrees_d(other.direction)),
            distance: Distance(Millimetres_u(other.distance))
        )
    }

// MARK: Creating Relative Coordinates
    
    /// Create a new `RelativeCoordinate`.
    ///
    /// - Parameter direction: The direction to the target.
    ///
    /// - Parameter distance: The distance to the target.
    public init(direction: Angle = .zero, distance: Distance = .zero) {
        self.direction = direction
        self.distance = distance
    }
    
// MARK: Calculating Other Relative Coordinates

    /// Calculate a relative coordinate to a coordinate in relation to the
    /// target.
    ///
    /// In other words, this function calculates trajectories between two
    /// coordinates. Let's say we have two coordinate A (`source -> target`)
    /// and B (`source -> coord`), then this function calculates
    /// C (`target -> coord`):
    /// ```
    ///
    ///
    ///
    ///                      A(0 degrees, 30cm)
    ///           source * ------------------> * target
    ///                   \                   /
    ///                    \                 /
    ///                     \               /
    ///                      \             /
    ///  B(-45 degrees, 60cm) \           / C (-74 degrees, 44cm)
    ///                        \         /
    ///                         \       /
    ///                          \     /
    ///                           \   /
    ///                            \ /
    ///                             V
    ///                             * coord
    ///
    ///
    ///
    /// ```
    ///
    /// - Parameter coord: The coordinate which will be the target of the new
    /// `RelativeCoordinate`.
    ///
    /// - Returns: The `RelativeCoordinate` from the target (`self`) to the
    /// new target (`coord`).
    public func relativeCoordinate(to coord: RelativeCoordinate) -> RelativeCoordinate {
        return self.cartesianCoordinate.relativeCoordinate(to: coord.cartesianCoordinate)
    }
    
// MARK: Converting to Field Specific Coordinates
    
    /// Convert this coordinate to a `CartesianCoordinate`.
    ///
    /// This assumes that source is the (0, 0) point facing 0 degrees.
    public var cartesianCoordinate: CartesianCoordinate {
        return CartesianCoordinate(rr_coord_to_cartesian_coord(self.rawValue))
    }

    /// Convert this coordinate to a `FieldCoordinate`.
    ///
    /// This assumes that source is the (0, 0) point facing 0 degrees.
    ///
    /// - Parameter heading: The heading of the resulting `FieldCoordinate`.
    ///
    /// - Returns: The target converted to a `FieldCoordinate`.
    public func fieldCoordinate(heading: Degrees_t) -> FieldCoordinate {
        return FieldCoordinate(rr_coord_to_field_coord(self.rawValue, heading.rawValue))
    }
    
// MARK: Calculations for Converting to Image Coordinates
    
    /// Convert this coordinate to a `CameraCoordinate`.
    ///
    /// This allows us to place the target within a specific image taken from a
    /// specific camera.
    ///
    /// - Parameter cameraPivot: The `CameraPivot` detailing the configuration
    /// of the pivot point in which the camera is placed, as well as detailing
    /// the cameras attached to the pivot point.
    ///
    /// - Parameter camera: The index of the camera which we are placing
    /// the target. This index should reference a valid `Camera` within the
    /// `cameras` array within `cameraPivot.cameras`.
    ///
    /// - Parameter resWidth: The width of the resolution of the image that
    /// we are placing the target in.
    ///
    /// - Parameter resHeight: The height of the resolution of the image that
    /// we are placing the target in.
    ///
    /// - Returns: The `CameraCoordinate` representing the target in the image
    /// at a specific pixel.
    ///
    /// - Warning: This function does not check whether the calculated
    /// coordinate is within the bounds of `resWidth` and `resHeight`. As such
    /// you should only use this function if you are positive that the camera
    /// can actually see the object at `coord`. If you would like to use a
    /// version of this function that performs this bounds check then use
    /// `cameraCoordinate(cameraPivot:camera:resWidth:resHeight:)`
    ///
    /// - SeeAlso: `CameraPivot`.
    /// - SeeAlso: `Camera`.
    /// - SeeAlso: `CameraCoordinate`.
    public func cameraCoordinate(cameraPivot: CameraPivot, camera: Int, resWidth: Pixels_u, resHeight: Pixels_u) -> CameraCoordinate {
        return self.pixelCoordinate(cameraPivot: cameraPivot, camera: camera, resWidth: resWidth, resHeight: resHeight).cameraCoordinate
    }
    
    /// Convert this coordinate to a `PixelCoordinate`.
    ///
    /// This allows us to place the target within a specific image taken from a
    /// specific camera.
    ///
    /// - Parameter cameraPivot: The `CameraPivot` detailing the configuration
    /// of the pivot point in which the camera is placed, as well as detailing
    /// the cameras attached to the pivot point.
    ///
    /// - Parameter camera: The index of the camera which we are placing
    /// the target. This index should reference a valid `Camera` within the
    /// `cameras` array within `cameraPivot.cameras`.
    ///
    /// - Parameter resWidth: The width of the resolution of the image that
    /// we are placing the target in.
    ///
    /// - Parameter resHeight: The height of the resolution of the image that
    /// we are placing the target in.
    ///
    /// - Returns: The `PixelCoordinate` representing the target in the image
    /// at a specific pixel.
    ///
    /// - Warning: This function does not check whether the calculated
    /// coordinate is within the bounds of `resWidth` and `resHeight`. As such
    /// you should only use this function if you are positive that the camera
    /// can actually see the object at `coord`. If you would like to use a
    /// version of this function that performs this bounds check then use
    /// `pixelCoordinate(cameraPivot:camera:resWidth:resHeight:)`
    ///
    /// - SeeAlso: `CameraPivot`.
    /// - SeeAlso: `Camera`.
    /// - SeeAlso: `PixelCoordinate`.
    public func pixelCoordinate(cameraPivot: CameraPivot, camera: Int, resWidth: Pixels_u, resHeight: Pixels_u) -> PixelCoordinate {
        return self.percentCoordinate(cameraPivot: cameraPivot, camera: camera).pixelCoordinate(resWidth: resWidth, resHeight: resHeight)
    }
    
    /// Convert this coordinate to a `PercentCoordinate`.
    ///
    /// This allows us to place the target within a specific image taken from a
    /// specific camera.
    ///
    /// - Parameter cameraPivot: The `CameraPivot` detailing the configuration
    /// of the pivot point in which the camera is placed, as well as detailing
    /// the cameras attached to the pivot point.
    ///
    /// - Parameter camera: The index of the camera which we are placing
    /// the target. This index should reference a valid `Camera` within the
    /// `cameras` array within `cameraPivot.cameras`.
    ///
    /// - Returns: The `PercentCoordinate` representing the target in the image
    /// at a specific pixel.
    ///
    /// - Warning: This function does not check whether the calculated
    /// coordinate is within the bounds of `resWidth` and `resHeight`. As such
    /// you should only use this function if you are positive that the camera
    /// can actually see the object at `coord`. If you would like to use a
    /// version of this function that performs this bounds check then use
    /// `percentCoordinate(cameraPivot:camera:)`
    ///
    /// - SeeAlso: `CameraPivot`.
    /// - SeeAlso: `Camera`.
    /// - SeeAlso: `PercentCoordinate`.
    public func percentCoordinate(cameraPivot: CameraPivot, camera: Int) -> PercentCoordinate {
        return PercentCoordinate(rr_coord_to_pct_coord(self.rawValue, cameraPivot.rawValue, CInt(camera)))
    }
    
    /// Calculate a pixel within a specific image from a specific camera
    /// representing the target.
    ///
    /// All calculated pixels that fall outside
    /// the bounds of the image are moved to the edge of the image to ensure
    /// that the function always calculates a coordinate within the image
    /// bounds.
    ///
    /// - Parameter cameraPivot: The `CameraPivot` detailing the configuration
    /// of the pivot point in which the camera is placed, as well as detailing
    /// the cameras attached to the pivot point.
    ///
    /// - Parameter camera: The index of the camera which recorded the image
    /// containing the pixel representing the target. This index should reference
    /// a valid `Camera` within the `cameras` array within
    /// `cameraPivot.cameras`.
    ///
    /// - Parameter resWidth: The width of the resolution of the image that
    /// we are placing the target in.
    ///
    /// - Parameter resHeight: The height of the resolution of the image that
    /// we are placing the target in.
    ///
    /// - Returns: A new `CameraCoordinate` representing the target in the
    /// camera.
    ///
    /// - SeeAlso: `PixelCoordinate`.
    /// - SeeAlso: `CameraPivot`.
    public func clampedCameraCoordinate(cameraPivot: CameraPivot, camera: Int, resWidth: Pixels_u, resHeight: Pixels_u) -> CameraCoordinate {
        return self.clampedPixelCoordinate(cameraPivot: cameraPivot, camera: camera, resWidth: resWidth, resHeight: resHeight).cameraCoordinate
    }
    
    /// Calculate a pixel within a specific image from a specific camera
    /// representing the target.
    ///
    /// All calculated pixels that fall outside
    /// the bounds of the image are moved to the edge of the image to ensure
    /// that the function always calculates a coordinate within the image
    /// bounds.
    ///
    /// - Parameter cameraPivot: The `CameraPivot` detailing the configuration
    /// of the pivot point in which the camera is placed, as well as detailing
    /// the cameras attached to the pivot point.
    ///
    /// - Parameter camera: The index of the camera which recorded the image
    /// containing the pixel representing the target. This index should reference
    /// a valid `Camera` within the `cameras` array within
    /// `cameraPivot.cameras`.
    ///
    /// - Parameter resWidth: The width of the resolution of the image that
    /// we are placing the target.
    ///
    /// - Parameter resHeight: The height of the resolution of the image that
    /// we are placing the target.
    ///
    /// - Returns: A new `PixelCoordinate` representing the object in the
    /// camera.
    ///
    /// - Warning: When tolerance is not nil, and the coordinate falls outside
    /// the specified tolerance, then the coordinate returned from this function
    /// will be outside the image resolution bounds.
    ///
    /// - SeeAlso: `PixelCoordinate`.
    /// - SeeAlso: `CameraPivot`.
    public func clampedPixelCoordinate(cameraPivot: CameraPivot, camera: Int, resWidth: Pixels_u, resHeight: Pixels_u) -> PixelCoordinate {
        return self.clampedPercentCoordinate(cameraPivot: cameraPivot, camera: camera).pixelCoordinate(resWidth: resWidth, resHeight: resHeight)
    }
    
    /// Calculate a point within a specific image from a specific camera
    /// representing the target.
    ///
    /// All calculated pixels that fall outside
    /// the bounds of the image are moved to the edge of the image to ensure
    /// that the function always calculates a coordinate within the image
    /// bounds.
    ///
    /// - Parameter cameraPivot: The `CameraPivot` detailing the configuration
    /// of the pivot point in which the camera is placed, as well as detailing
    /// the cameras attached to the pivot point.
    ///
    /// - Parameter camera: The index of the camera which recorded the image
    /// containing the pixel representing the target. This index should reference
    /// a valid `Camera` within the `cameras` array within
    /// `cameraPivot.cameras`.
    ///
    /// - Parameter resWidth: The width of the resolution of the image that
    /// we are placing the target in.
    ///
    /// - Parameter resHeight: The height of the resolution of the image that
    /// we are placing the target in.
    ///
    /// - Returns: A new `PercentCoordinate` representing the object in the
    /// camera.
    ///
    /// - Warning: When tolerance is not nil, and the coordinate falls outside
    /// the specified tolerance, then the coordinate returned from this function
    /// will be outside the image resolution bounds.
    ///
    /// - SeeAlso: `PercentCoordinate`.
    /// - SeeAlso: `CameraPivot`.
    public func clampedPercentCoordinate(cameraPivot: CameraPivot, camera: Int) -> PercentCoordinate {
        return PercentCoordinate(clamped_rr_coord_to_pct_coord(self.rawValue, cameraPivot.rawValue, CInt(camera)))
    }

}

extension RelativeCoordinate: Equatable, Hashable, Codable, AdditiveArithmetic {}
